@OperatorV2 @Core @UtilitiesID @BulkAddressVerificationID
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: ID - Populate Pricing Info with Address Billing Zone L1-L3 upon Bulk Address Verification (uid:5ef7b107-a135-47df-a883-18308ffab45a)
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
      | fromBillingZone.l1_id       | {KEY_LIST_OF_FOUND_ZONES_INFO[1].l1Id}        |
      | fromBillingZone.l1_name     | {KEY_LIST_OF_FOUND_ZONES_INFO[1].l1Name}      |
      | fromBillingZone.l2_id       | {KEY_LIST_OF_FOUND_ZONES_INFO[1].l2Id}        |
      | fromBillingZone.l2_name     | {KEY_LIST_OF_FOUND_ZONES_INFO[1].l2Name}      |
      | fromBillingZone.l3_id       | {KEY_LIST_OF_FOUND_ZONES_INFO[1].l3Id}        |
      | fromBillingZone.l3_name     | {KEY_LIST_OF_FOUND_ZONES_INFO[1].l3Name}      |
      | toBillingZone.billingZone   | {KEY_LIST_OF_FOUND_ZONES_INFO[2].billingZone} |
      | toBillingZone.latitude      | <toLatitude>                                  |
      | toBillingZone.longitude     | <toLongitude>                                 |
      | toBillingZone.l1_id         | {KEY_LIST_OF_FOUND_ZONES_INFO[2].l1Id}        |
      | toBillingZone.l1_name       | {KEY_LIST_OF_FOUND_ZONES_INFO[2].l1Name}      |
      | toBillingZone.l2_id         | {KEY_LIST_OF_FOUND_ZONES_INFO[2].l2Id}        |
      | toBillingZone.l2_name       | {KEY_LIST_OF_FOUND_ZONES_INFO[2].l2Name}      |
      | toBillingZone.l3_id         | {KEY_LIST_OF_FOUND_ZONES_INFO[2].l3Id}        |
      | toBillingZone.l3_name       | {KEY_LIST_OF_FOUND_ZONES_INFO[2].l3Name}      |
    Examples:
      | fromLatitude | fromLongitude | toLatitude | toLongitude |
      | -6.1594307   | 106.7856113   | -8.0021898 | 110.503534  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
