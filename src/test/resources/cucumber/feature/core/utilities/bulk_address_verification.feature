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

  Scenario Outline: SG - Populate Pricing Info with Address Billing Zone L1-L3 upon Bulk Address Verification (uid:a4e7eef3-2daa-4cbb-b708-48e9d44d8cde)
    Given API Operator get Billing Zone info:
      | latitude       | longitude       |
      | <fromLatitude> | <fromLongitude> |
      | <toLatitude>   | <toLongitude>   |
    And API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1 ID","phone_number":"+6281386061359","email":"customer.return.kuc8tny9@ninjavan.co","address": {"contact": "+6598980057","email": "address.sg.6598980000@ninjavan.co","address1": "34 LORONG 30 GEYLANG","address2": "1-1","postcode": "398367","country": "SG","city": "SG","state": "Singapore","sub_district": "sub district","district": "district","street": "Street","latitude":<fromLatitude>,"longitude":<fromLongitude>}},"to":{"name":"George Ezra","phone_number":"+6281386061359","email":"address.sg.6598980000@ninjavan.co","address":{"contact": "+6598980001","email": "address.sg.6598980000@ninjavan.co","address1": "8 MARINA BOULEVARD","address2": "#01-01","postcode": "018981","country": "SG","city": "SG","state": "Singapore","sub_district":"sub district","district":"district","street":"Marina St","latitude":<toLatitude>,"longitude":<toLongitude>}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | <toLatitude>               |
      | longitude | <toLongitude>              |
    Then DB Operator verify pricing info of "KEY_CREATED_ORDER_ID" order:
      | fromBillingZone.billingZone | {KEY_LIST_OF_FOUND_ZONES_INFO[1].billingZone} |
      | fromBillingZone.latitude    | <fromLatitude>                                |
      | fromBillingZone.longitude   | <fromLongitude>                               |
      | fromBillingZone.l1_id       | null                                          |
      | fromBillingZone.l1_name     | null                                          |
      | fromBillingZone.l2_id       | null                                          |
      | fromBillingZone.l2_name     | null                                          |
      | fromBillingZone.l3_id       | null                                          |
      | fromBillingZone.l3_name     | null                                          |
      | toBillingZone.billingZone   | {KEY_LIST_OF_FOUND_ZONES_INFO[2].billingZone} |
      | toBillingZone.latitude      | <toLatitude>                                  |
      | toBillingZone.longitude     | <toLongitude>                                 |
      | toBillingZone.l1_id         | null                                          |
      | toBillingZone.l1_name       | null                                          |
      | toBillingZone.l2_id         | null                                          |
      | toBillingZone.l2_name       | null                                          |
      | toBillingZone.l3_id         | null                                          |
      | toBillingZone.l3_name       | null                                          |
    Examples:
      | fromLatitude | fromLongitude | toLatitude | toLongitude |
      | 1.2853069    | 103.8061058   | 1.3880089  | 103.8946339 |

  @DeleteOrArchiveRoute
  Scenario: Operator Bulk Verify Reservation Addresses by Upload CSV Successfully
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_RESERVATIONS |
      | latitude  | GENERATED                 |
      | longitude | GENERATED                 |
    Then Operator verifies that success react notification displayed:
      | top | Updated 2 waypoint(s) |
    Then DB Operator verify Jaro Scores:
      | waypointId                                      | archived | score | sourceId |
      | {KEY_LIST_OF_CREATED_JARO_SCORES[1].waypointId} | 1        | 1     | 4        |
      | {KEY_LIST_OF_CREATED_JARO_SCORES[2].waypointId} | 1        | 1     | 4        |
    And DB Operator verifies waypoints record:
      | id        | {KEY_LIST_OF_CREATED_JARO_SCORES[1].waypointId} |
      | latitude  | {KEY_LIST_OF_CREATED_JARO_SCORES[1].latitude}   |
      | longitude | {KEY_LIST_OF_CREATED_JARO_SCORES[1].longitude}  |
    And DB Operator verifies waypoints record:
      | id        | {KEY_LIST_OF_CREATED_JARO_SCORES[2].waypointId} |
      | latitude  | {KEY_LIST_OF_CREATED_JARO_SCORES[2].latitude}   |
      | longitude | {KEY_LIST_OF_CREATED_JARO_SCORES[2].longitude}  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
