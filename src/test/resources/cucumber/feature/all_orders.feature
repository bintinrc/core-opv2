@OperatorV2 @AllOrders
Feature: All Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator download sample CSV file for "Find Orders with CSV" on All Orders page (uid:d95ad43b-5dda-4747-8eb5-4d77e5aaa9d5)
    Given Operator go to menu Order -> All Orders
    When Operator download sample CSV file for "Find Orders with CSV" on All Orders page
    Then Operator verify sample CSV file for "Find Orders with CSV" on All Orders page is downloaded successfully

  Scenario: Operator find new pending pickup order by using Specific Search on All Orders page (uid:3e6ffaf7-ca06-42e3-a68c-959e287f4afe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When API Operator get order details
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | {shipper-v2-prefix} |
    Then Operator filter the result table by Tracking ID on All Orders page and verify order info is correct

  Scenario Outline: Operator find new pending pickup order on All Orders page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When API Operator get order details
    Then Operator verify the new pending pickup order is found on All Orders page with correct info
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:cf30bd2e-9214-461c-900d-7d7b6c966242 | Normal    |
      | C2C    | uid:7257ec3c-1efc-405f-bc7a-b2effc1362f0 | C2C       |
      | Return | uid:85546b4d-7586-4658-a4e1-02b3406099cb | Return    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
