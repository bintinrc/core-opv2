@OperatorV2 @CodReport @Saas
Feature: COD Report

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator is able to load CODs For A Day and verify the created order is exist and contains correct info (uid:7a62cd75-28e9-4dea-ad8a-b44c44d470b9)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "cod_goods":23.57, "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When API Operator get order details
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get CODs For A Day" and Date = "{current-date-yyyy-MM-dd}"
    Then Operator verify order is exist on COD Report table with correct info

  @ArchiveRouteViaDb
  Scenario: Operator is able to load Driver CODs For A Route Day and verify the created order is exist and contains correct info (uid:c03caac5-c0e9-470d-a740-ef3fcdc9a835)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "cod_goods":23.57, "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator get order details
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get Driver CODs For A Route Day" and Date = "{current-date-yyyy-MM-dd}"
    Then Operator verify order is exist on COD Report table with correct info

  Scenario: Operator is able to download CODs For A Day and verify the data is correct (uid:569b8003-7e8d-4afe-92ed-c54a8daaf290)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "cod_goods":23.57, "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get CODs For A Day" and Date = "{current-date-yyyy-MM-dd}"
    When Operator download COD Report
    When API Operator get order details
    Then Operator verify the downloaded COD Report data is correct

  @ArchiveRouteViaDb
  Scenario: Operator is able to download Driver CODs For A Route Day and verify the data is correct (uid:92b275ec-79ee-4162-bd72-2923736f5460)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "cod_goods":23.57, "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Analytics -> COD Report
    When Operator filter COD Report by Mode = "Get Driver CODs For A Route Day" and Date = "{current-date-yyyy-MM-dd}"
    When Operator download COD Report
    When API Operator get order details
    Then Operator verify the downloaded COD Report data is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
