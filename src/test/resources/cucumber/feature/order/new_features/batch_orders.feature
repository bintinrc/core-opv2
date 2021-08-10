@OperatorV2 @Order @NewFeatures @BatchOrders
Feature: Batch Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Fetch orders by batch ID - valid batch ID (uid:d4cd4866-4c4e-426f-80c2-1af724767ab2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V4
    When Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:
      | shipperId         | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator verify order V4 is created successfully on Order Creation V4 page
    When Operator go to menu New Features -> Batch Order
    And Operator search for created Batch Order on Batch Orders page
    Given API Operator retrieve information about Bulk Order
    Then Operator verify the list of orders are correct

  Scenario: Fetch orders by batch ID - invalid batch ID (uid:2ae9223d-d425-4415-a337-c22ec7d91758)
    When Operator go to menu New Features -> Batch Order
    And Operator search invalid batch ID on Batch Orders page
    Then Operator verify the invalid batch ID error toast is shown

  Scenario: Rollback orders by batch ID - Valid Order Status (uid:297e19a0-bf7a-43ff-974d-4fc498c064f6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V4
    When Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:
      | shipperId         | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator verify order V4 is created successfully on Order Creation V4 page
    When Operator go to menu New Features -> Batch Order
    And Operator search for created Batch Order on Batch Orders page
    Given API Operator retrieve information about Bulk Order
    Then Operator verify the list of orders are correct
    When Operator rollback the batch order
    Then DB Operator verify the orders are deleted in core_qa_sg.order_batch_items DB

  Scenario: Rollback orders by batch ID - Invalid Order Status (uid:fd077341-59c7-4584-ab0d-44b9c0f8b428)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V4
    When Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:
      | shipperId         | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator verify order V4 is created successfully on Order Creation V4 page
    Given API Operator retrieve information about Bulk Order
    When Get created batch order
    And API Operator cancel created order
    When Operator go to menu New Features -> Batch Order
    And Operator search for created Batch Order on Batch Orders page
    When Operator rollback the batch order
    Then Operator verify the invalid order status error toast is shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op