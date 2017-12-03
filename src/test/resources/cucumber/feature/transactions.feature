@Transactions @selenium @Transactions#01
Feature: Transactions

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Add transaction to Route Group (uid:b6848852-12e6-4cba-bf7c-8444538596c1)
    #Notes: Shipper create sameday parcel with OC V2
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | true |
    When Operator go to menu Routing -> 2. Route Group Management
    Then new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    When Operator V2 add created Transaction to Route Group
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser
  Scenario: Kill Browser
