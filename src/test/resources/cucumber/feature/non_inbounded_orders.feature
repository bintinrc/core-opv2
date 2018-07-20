@OperatorV2Disabled @NonInboundedOrders
Feature: Non Inbounded Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator find Pending Pickup order on page Non Inbounded Orders
    #This step is already implemented.
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    #This step is already implemented.
    Given Operator go to menu New Features -> Non Inbounded Orders

    When Operator select filter and click Load Selection on page Non Inbounded Orders using data below:
      | routeDate   | {current-date-yyyy-MM-dd} |
      | shipperName | {shipper-v2-name}         |
    When Operator find Pending Pickup order on page Non Inbounded Orders
    Then Operator verify the order is found on page Non Inbounded Orders's table

  Scenario: Operator should not find Global Inbounded order on page Non Inbounded Orders
    #This step is already implemented.
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    #This step is already implemented.
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    #This step is already implemented.
    Given Operator go to menu New Features -> Non Inbounded Orders

    When Operator select filter and click Load Selection on page Non Inbounded Orders using data below:
      | routeDate   | {current-date-yyyy-MM-dd} |
      | shipperName | {shipper-v2-name}         |
    When Operator find Pending Pickup order on page Non Inbounded Orders
    Then Operator verify the order is NOT found on page Non Inbounded Orders's table

  Scenario: Operator should be able to Cancel multiple selected orders on page Non Inbounded Orders
    #This step is already implemented.
    Given API Shipper create multiple Order V2 Parcel using data below:
      | numberOfOrder     | 2      |
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    #This step is already implemented.
    Given Operator go to menu New Features -> Non Inbounded Orders

    When Operator select filter and click Load Selection on page Non Inbounded Orders using data below:
      | routeDate   | {current-date-yyyy-MM-dd} |
      | shipperName | {shipper-v2-name}         |
    When Operator select all created orders on the table and do Cancel Order on page Non Inbounded Orders
    Then Operator verify all orders is not found on page Non Inbounded Order's table anymore

  Scenario: Operator should be able to Download CSV of multiple selected orders on page Non Inbounded Orders
  #This step is already implemented.
    Given API Shipper create multiple Order V2 Parcel using data below:
      | numberOfOrder     | 2      |
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
  #This step is already implemented.
    Given Operator go to menu New Features -> Non Inbounded Orders

    When Operator select filter and click Load Selection on page Non Inbounded Orders using data below:
      | routeDate   | {current-date-yyyy-MM-dd} |
      | shipperName | {shipper-v2-name}         |
    When Operator select all created orders on the table and do Download CSV File on page Non Inbounded Orders
    Then Operator verify the CSV of selected Non Inbounded Orders is downloaded successfully and contains correct info

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
