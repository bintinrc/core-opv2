@OperatorV2 @VanInbound
Feature: Van Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario: Operator van inbounds the created order with valid tracking ID
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":2, "hubId":1, "vehicleId":1, "driverId":1608 } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    When Operator go to menu Inbounding -> Van Inbound
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding

  @ArchiveRoute
  Scenario: Operator van inbounds the created order with invalid tracking ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":2, "hubId":1, "vehicleId":1, "driverId":1608 } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the invalid tracking ID INVALID_TRACKING_ID on Van Inbound Page
    Then Operator verify the tracking ID INVALID_TRACKING_ID that has been input on Van Inbound Page is invalid

  @ArchiveRoute
  Scenario: Operator van inbounds the created order with empty tracking ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":2, "hubId":1, "vehicleId":1, "driverId":1608 } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the empty tracking ID on Van Inbound Page
    Then Operator verify the tracking ID that has been input on Van Inbound Page is empty

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser