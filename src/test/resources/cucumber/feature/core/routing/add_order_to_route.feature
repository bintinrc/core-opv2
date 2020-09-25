@OperatorV2 @Core @Routing @AddOrderToRoute
Feature: Add Order To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add Order to a Route - Valid Tracking ID, With Prefix (uid:44589e4d-860b-45ac-a50e-add9f5aedf4a)
    Given Operator go to menu Routing -> Add Order to Route
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator add the route and transaction type
    When Operator add the prefix
    And Operator enters the valid tracking id
    Then Operator verifies the last scanned with prefix tracking id
    Then Operator verifies latest event is "ADD TO ROUTE"
    Then DB operator gets details for transactions table for route
    And Operator verifies transaction tables for route

  Scenario: Add Order to a Route - Invalid Tracking ID, With Prefix (uid:ce2a5e6b-f06d-4c6d-9f9c-656ac605b3bb)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Add Order to Route
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator add the route and transaction type
    When Operator add the prefix
    And Operator enters the invalid tracking Id
    Then Operator verifies the last scanned with prefix tracking id
    And Operator verifies error messages

  Scenario: Add Order to a Route - Valid Tracking ID, No Prefix (uid:777598b1-78a7-4e36-bdc3-7345f32ab40a)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Add Order to Route
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator add the route and transaction type
    And Operator enters the valid tracking id
    Then Operator verifies the last scanned without prefix tracking id
    And Operator verifies the success messages
    Given Operator go to menu Order -> All Orders
    Then Operator verifies latest event is "ADD TO ROUTE"
    Then DB operator gets details for transactions table for route
    And Operator verifies transaction tables for route

  Scenario: Add Order to a Route - Invalid Tracking ID, No Prefix (uid:e09d356e-d21f-462a-b26f-a2631203662e)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Add Order to Route
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator add the route and transaction type
    And Operator enters the invalid tracking Id
    Then Operator verifies the last scanned without prefix tracking id
    And Operator verifies error messages without prefix


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op