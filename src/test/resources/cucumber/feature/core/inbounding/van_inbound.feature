@OperatorV2 @Core @Inbounding @VanInbound
Feature: Van Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds And Starts Route with Valid Tracking ID (uid:677bce9c-ca6e-4842-99e7-ccecba82f2d8)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    Then Operator verify the van inbound process is succeed
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order scan updated
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator go to menu Routing -> Route Logs
    Then Operator verify the route is started after van inbounding using data below:
      | routeDateFrom | {gradle-current-date-yyyy-MM-dd} |
      | routeDateTo   | {gradle-current-date-yyyy-MM-dd} |
      | hubName       | {hub-name}                       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | DRIVER INBOUND SCAN  |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verifies inbound_scans record with type "4" and correct route_id

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds with Invalid Tracking ID (uid:fd5c0c47-7a31-44f7-b2dd-d07bd9a0645f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the invalid tracking ID INVALID_TRACKING_ID on Van Inbound Page
    Then Operator verify the tracking ID INVALID_TRACKING_ID that has been input on Van Inbound Page is invalid

  @DeleteOrArchiveRoute
  Scenario: Operator Van Inbounds with Empty Tracking ID (uid:d04f2df6-82f8-455a-a1a5-91db0fc6962a)
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