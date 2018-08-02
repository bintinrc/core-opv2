@OperatorV2Disabled @DpTagging
Feature: DP Tagging

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator verify invalid DP Tagging CSV is not uploaded successfully (uid:754b9a0d-67c0-4012-bb7a-ec786e24bed3)
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator uploads invalid DP Tagging CSV
    Then Operator verify invalid DP Tagging CSV is not uploaded successfully

  Scenario Outline: Operator tagged single order to DP (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with ID = "{dp-id}"
    Then Operator verify the order(s) is tagged to DP successfully
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:c798aa53-3cab-4d3b-80e8-23849cfda6c5 | Normal    | false            |
      | Return | uid:c9fcc03b-99cc-41ee-91d0-ae2e46e74774 | Return    | true             |
      | C2C    | uid:192326b0-9a43-4017-91c7-e8312d6f58ce | C2C       | true             |

  Scenario: Operator tagged multiple order to DP (uid:d3342895-66f9-4e9e-bfb7-7bc369d94b55)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3      |
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags multiple orders to DP with ID = "{dp-id}"
    Then Operator verify the order(s) is tagged to DP successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
