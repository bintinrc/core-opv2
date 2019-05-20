@OperatorV2 @OperatorV2Part2 @OrderWeightUpdateV2
Feature: Order Weight Update V2

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator create order V2 on Order Weight Update V2 (<hiptest-uid> )
    Given Operator go to menu Order -> All Orders
    Given API create order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Special Pages -> Order Weight Update
    When Operator Order Weight update CSV Upload on Order Weight Update V2 page
    | weight | 4 |
    Then Operator Order Weight update on Order Weight Update V2 page
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {shipper-v4-prefix} |
    Then Operator filter the result table by Tracking ID on All Orders page and verify order info is correct
    Then Operator Edit Order on Order Weight Update V2 page
    Then Operator Verify Order Weight on Order Weight Update V2 page
    Examples:a
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:e58a4c81-1b83-4115-bbee-584764277d30 | Normal    |
  Scenario: Operator Create multiple orders with CSV on All Orders page (uid:932287da-cf04-471e-b056-e3c44c233677)
    Given Operator go to menu menu Order -> All Orders
    Given API create multiple V4 orders using data below:
      | numberOfOrder     | 3      |
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Special Pages -> Order Weight Update
    When Operator Multiple Order Weight update CSV Upload on Order Weight Update V2 page
    | 4 |
    | 5 |
    | 6 |
    Given Operator go to menu menu Order -> All Orders
        When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {shipper-v4-prefix} |
  Then Operator verify all orders Weights Updated  on All Orders page with correct info


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
