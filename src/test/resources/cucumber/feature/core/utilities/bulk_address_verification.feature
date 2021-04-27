@OperatorV2 @Core @Utilities @BulkAddressVerification
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Verify Addresses by Upload CSV Successfully (uid:9aefdd19-47df-42e9-ad40-15fd942c0015)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | GENERATED                  |
      | longitude | GENERATED                  |
    Then Operator verify Jaro Scores are created successfully

  Scenario: Operator Download Bulk Address Verify Sample CSV File (uid:88b8b4ab-f130-47b1-b317-54eb770ad5e8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator download sample CSV file on Bulk Address Verification page
    Then sample CSV file on Bulk Address Verification page is downloaded successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
