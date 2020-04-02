@OperatorV2 @OperatorV2Part2
Feature: Add Order To Route

  @LaunchBrowser @ShouldAlwaysRun @test
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add order to a route - Valid Tracking ID, Prefix Using (uid:8d3eb4d1-b0a7-4ab4-98aa-26722de59027)
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

  Scenario: Add order to a route - Invalid Tracking ID, Prefix Using (uid:39fa3ecb-d1f0-4eb8-ae2c-eabf23d83a75)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Add Order to Route
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator add the route and transaction type
    When Operator add the prefix
    And Operator enters the invalid tracking Id
    Then Operator verifies the last scanned with prefix tracking id
    And Operator verifies error messages

  Scenario: Add order to a route - Valid Tracking ID, No Prefix (uid:a46d6a08-707a-4418-ab45-693e4e917216)
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

  Scenario: Add order to a route - Invalid Tracking ID, No Prefix (uid:a4e6e785-488d-43e0-a89a-60578fcad94b)
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