@OperatorV2 @OperatorV2Part1 @VanInbound @Saas @Inbound
Feature: Van Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator van inbounds the created order with valid tracking ID (uid:dbb54d2b-a9a4-4975-b9db-456680953a54)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    When Operator go to menu Order -> All Orders
    Then Operator verify order scan updated
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | TODAY      |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |

  @ArchiveRouteViaDb
  Scenario: Operator van inbounds the created order with invalid tracking ID (uid:b91adc47-ea7d-412f-8166-175f0816809f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the invalid tracking ID INVALID_TRACKING_ID on Van Inbound Page
    Then Operator verify the tracking ID INVALID_TRACKING_ID that has been input on Van Inbound Page is invalid

  @ArchiveRouteViaDb
  Scenario: Operator van inbounds the created order with empty tracking ID (uid:485bf214-d45a-45b2-9696-179c9d5afe3d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the empty tracking ID on Van Inbound Page
    Then Operator verify the tracking ID that has been input on Van Inbound Page is empty

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op