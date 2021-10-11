@OperatorV2 @Core @NewFeatures @OrderParcelSizeUpdate
Feature: Order Parcel Size Update

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download sample CSV file for Order Parcel Size Update (uid:7d7f5b59-94a2-43b1-a790-b3b7b16683dd)
    Given Operator go to menu New Features -> Order Parcel Size Update
    When Operator download sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page
    Then sample CSV file for 'Find Orders with CSV' on Order Parcel Size Update page is downloaded successfully

  Scenario: Operator update order parcel size by upload CSV file with Multiple Orders (uid:648914ff-d42e-42e6-a045-fff580f36773)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    Then Operator verifies that success toast displayed:
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op