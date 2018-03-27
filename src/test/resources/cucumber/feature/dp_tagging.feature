@OperatorV2 @DpTagging
Feature: DP Tagging

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator verify invalid DP Tagging CSV is not uploaded successfully (uid:754b9a0d-67c0-4012-bb7a-ec786e24bed3)
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator uploads invalid DP Tagging CSV
    Then Operator verify invalid DP Tagging CSV is not uploaded successfully

  Scenario Outline: Operator tagged single order to DP (uid:491059a4-3343-44e2-940a-b021ab81c95d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with ID = "{dp-id}"
    Then Operator verify the order(s) is tagged to DP successfully
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:c798aa53-3cab-4d3b-80e8-23849cfda6c5 | Normal    |
      | C2C    | uid:192326b0-9a43-4017-91c7-e8312d6f58ce | C2C       |
      | Return | uid:c9fcc03b-99cc-41ee-91d0-ae2e46e74774 | Return    |

  Scenario: Operator tagged multiple order to DP (uid:d3342895-66f9-4e9e-bfb7-7bc369d94b55)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple Order V2 Parcel using data below:
      | numberOfOrder     | 3       |
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags multiple orders to DP with ID = "{dp-id}"
    Then Operator verify the order(s) is tagged to DP successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
