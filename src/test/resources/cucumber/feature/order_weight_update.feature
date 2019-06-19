@OperatorV2 @OperatorV2Part2Disabled @OrderWeightUpdate
Feature: Order Weight Update V2

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create order V2 on Order Weight Update V2
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Special Pages -> Order Weight Update
    When Operator Order Weight update CSV Upload on Order Weight Update V2 page
      | new-weight-in-double-format | 4.5 |
    Then Operator Order Weight update on Order Weight Update V2 page
    When Operator go to menu Order -> All Orders
    Then API Order weight verify info after order update

  Scenario: Operator Create multiple orders with CSV on All Orders page
    Given Operator go to menu menu Order -> All Orders
    Given API create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Special Pages -> Order Weight Update
    When Operator Multiple Order Weight update CSV Upload on Order Weight Update V2 page
      | 2.4 |
      | 2.5 |
      | 2.6 |
    Given Operator go to menu menu Order -> All Orders
    Then API Multi Order weight verify info after order update
  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
