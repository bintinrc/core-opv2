@OperatorV2 @OperatorV2Part2 @BulkAddressVerification @Saas
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator should be able to verify Bulk Addresses on Bulk Address Verification page (uid:ae74df19-c939-4b91-865d-94eb19021910)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple Order V2 Parcel using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                      |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}" } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    When Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | GENERATED                  |
      | longitude | GENERATED                  |
    Then Operator verify Jaro Scores are created successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
