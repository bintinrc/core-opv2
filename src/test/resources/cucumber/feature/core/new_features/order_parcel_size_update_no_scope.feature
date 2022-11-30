@OperatorV2 @Core @NewFeatures @OrderParcelSizeUpdate @NewFeatures2
Feature: Order Parcel Size Update

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator is in Operator Portal V2 login page
    When Operator click login button
    Given Operator login as "{operator-portal-uid-2}" with password "{operator-portal-pwd-2}"

  Scenario: Operator update order parcel size by upload CSV file with Multiple Orders - User has no scope
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu New Features -> Order Parcel Size Update
    And Operator upload Multiple Order Parcel Size update CSV on Order Parcel Size Update page
      | MEDIUM |
      | LARGE  |
    Then Operator verifies that info toast displayed:
      | top | Matches with file shown in table |
    When Operator clicks Upload button on Order Parcel Size Update page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                                                                          |
      | bottom | ^.*Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : UPDATE_PARCEL_SIZE_WEIGHT_DIMENSIONS,ALL_ACCESS,INTERNAL_SERVICE.* |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verifies dimensions information on Edit Order page:
      | size | SMALL |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verifies dimensions information on Edit Order page:
      | size | SMALL |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op