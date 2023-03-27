@Sort @Utilities @BulkAddressVerificationPart2
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk AV Reservation - RTS zone exist
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 5               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_RESERVATION_DETAILS |
      | latitude  | FROM_CONFIG_RTS                  |
      | longitude | FROM_CONFIG_RTS                  |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV Reservation - Zone is NULL
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 5               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_RESERVATION_DETAILS |
      | latitude  | FROM_CONFIG_OOZ                  |
      | longitude | FROM_CONFIG_OOZ                  |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV RTS orders - Empty Waypoint ID
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | EMPTY     |
      | latitude  | GENERATED |
      | longitude | GENERATED |

  Scenario: Bulk AV RTS orders - Valid and Empty Waypoint ID
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | MIX             |
      | latitude  | FROM_CONFIG_RTS |
      | longitude | FROM_CONFIG_RTS |
    And Operator verifies waypoints are assigned to "RTS" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Download Bulk AV Sample CSV File
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator download sample CSV file on Bulk Address Verification page
    Then sample CSV file on Bulk Address Verification page is downloaded successfully

  Scenario Outline: SG - Populate Pricing Info with Address Billing Zone L1-L3 upon Bulk Address Verification
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
    And Operator clicks Update successful matched on Bulk Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Updated 1 waypoint(s) |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op