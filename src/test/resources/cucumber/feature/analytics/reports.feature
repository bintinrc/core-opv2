@OperatorV2 @Analytics @OperatorV2Part2 @Reports
Feature: Order Creation V4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Generate/send Driver CODs for A Day Report (uid:3e252f0a-e0f3-4e17-8f52-17e5a8bfc237)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator get order details
    Given Operator go to menu Analytics -> Reports
    When Operator filter COD Reports by Mode = "Get CODs For A Day" and Date = "{gradle-current-date-yyyy-MM-dd}"
    And  Operator generate COD Reports
    Then Verify the COD reports attachments are sent to the Operator email

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
