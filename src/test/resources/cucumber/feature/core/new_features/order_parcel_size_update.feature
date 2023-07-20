@OperatorV2 @Core @NewFeatures @OrderParcelSizeUpdate @NewFeatures2
Feature: Order Parcel Size Update

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download sample CSV file for Order Parcel Size Update
    Given Operator go to menu New Features -> Order Parcel Size Update
    When Operator download sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page
    Then sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page is downloaded successfully

  Scenario: Operator update order parcel size by upload CSV file with Multiple Orders
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Order Parcel Size Update
    And Operator upload Multiple Order Parcel Size update CSV on Order Parcel Size Update page
      | MEDIUM |
      | LARGE  |
    Then Operator verifies that success react notification displayed:
      | top | Matches with file shown in table |
    When Operator clicks Upload button on Order Parcel Size Update page
    Then Operator verifies that success react notification displayed:
      | top                | Parcel size update success |
      | waitUntilInvisible | true                       |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verifies dimensions information on Edit Order page:
      | size | MEDIUM |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verifies dimensions information on Edit Order page:
      | size | LARGE |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page
