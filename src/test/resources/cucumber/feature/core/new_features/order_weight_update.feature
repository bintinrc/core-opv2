@OperatorV2 @Core @NewFeatures @OrderWeightUpdate
Feature: Order Weight Update V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Update Order Weight by Upload CSV - Single Order (uid:aa549ffc-adeb-4e00-a92d-a22275c68eb1)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Order Weight Update
    When Operator Order Weight update CSV Upload on Order Weight Update V2 page
      | new-weight-in-double-format | 4.5 |
    Then Operator Order Weight update on Order Weight Update V2 page

  Scenario: Operator Update Order Weight by Upload CSV - Multiple Orders (uid:c6c8c196-0a84-49d2-9e08-a97d9835a2d8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu New Features -> Order Weight Update
    When Operator Multiple Order Weight update CSV Upload on Order Weight Update V2 page
      | 2.4 |
      | 2.5 |
      | 2.6 |
    Then Operator Order Weight update on Order Weight Update V2 page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op