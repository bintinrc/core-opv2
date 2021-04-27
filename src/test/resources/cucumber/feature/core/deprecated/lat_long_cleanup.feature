@Deprecated
Feature: Lat/Long Cleanup

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Update Waypoint Details on Lat/Long Cleanup Page (uid:6f6eeeb9-abc3-47cf-af82-9f42e5829750)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    When Operator go to menu Utilities -> Lat/Lng Cleanup
    And Operator edit created delivery waypoint on Lat/Lng Cleanup page using data below:
      | address1   | GENERATED |
      | address2   | GENERATED |
      | city       | GENERATED |
      | country    | GENERATED |
      | postalCode | GENERATED |
      | latitude   | GENERATED |
      | longitude  | GENERATED |
    Then Operator verify waypoint details on Lat/Lng Cleanup page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
