@Sort @Utilities @BulkAddressVerificationSG
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario Outline: SG - Populate Pricing Info with Address Billing Zone L1-L3 upon Bulk Address Verification
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Sort - Operator get Billing Zone info:
      | latitude       | longitude       |
      | <fromLatitude> | <fromLongitude> |
      | <toLatitude>   | <toLongitude>   |
    And API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1 ID","phone_number":"+6281386061359","email":"customer.return.kuc8tny9@ninjavan.co","address": {"contact": "+6598980057","email": "address.sg.6598980000@ninjavan.co","address1": "34 LORONG 30 GEYLANG","address2": "1-1","postcode": "398367","country": "SG","city": "SG","state": "Singapore","sub_district": "sub district","district": "district","street": "Street","latitude":<fromLatitude>,"longitude":<fromLongitude>}},"to":{"name":"George Ezra","phone_number":"+6281386061359","email":"address.sg.6598980000@ninjavan.co","address":{"contact": "+6598980001","email": "address.sg.6598980000@ninjavan.co","address1": "8 MARINA BOULEVARD","address2": "#01-01","postcode": "018981","country": "SG","city": "SG","state": "Singapore","sub_district":"sub district","district":"district","street":"Marina St","latitude":<toLatitude>,"longitude":<toLongitude>}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude     | longitude     |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | <toLatitude> | <toLongitude> |
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Updated 1 waypoint(s) |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify pricing info of order with:
      | expectedfromBillingZone.billingZone | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.billingZone} |
      | expectedfromBillingZone.latitude    | <fromLatitude>                                                          |
      | expectedfromBillingZone.longitude   | <fromLongitude>                                                         |
      | expectedfromBillingZone.l1_id       | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.l1_id}       |
      | expectedfromBillingZone.l1_name     | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.l1_name }    |
      | expectedfromBillingZone.l2_id       | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.l2_id}       |
      | expectedfromBillingZone.l2_name     | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.l2_name}     |
      | expectedfromBillingZone.l3_id       | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.l3_id}       |
      | expectedfromBillingZone.l3_name     | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.l3_name}     |
      | expectedtoBillingZone.billingZone   | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.toBillingZone.billingZone}   |
      | expectedtoBillingZone.latitude      | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.latitude}  |
      | expectedtoBillingZone.longitude     | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.longitude} |
      | expectedtoBillingZone.l1_id         | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.l1_id}     |
      | expectedtoBillingZone.l1_name       | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.l1_name}   |
      | expectedtoBillingZone.l2_id         | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.l2_id}     |
      | expectedtoBillingZone.l2_name       | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.l2_name}   |
      | expectedtoBillingZone.l3_id         | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.l3_id}     |
      | expectedtoBillingZone.l3_name       | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.tofromBillingZone.l3_name}   |
      | fromBillingZone.billingZone         | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].billingZone}                      |
      | fromBillingZone.latitude            | <fromLatitude>                                                          |
      | fromBillingZone.longitude           | <fromLongitude>                                                         |
      | fromBillingZone.l1_id               | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].l1Id}                             |
      | fromBillingZone.l1_name             | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].l1Name}                           |
      | fromBillingZone.l2_id               | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].l2Id}                             |
      | fromBillingZone.l2_name             | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].l2Name}                           |
      | fromBillingZone.l3_id               | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].l3Id}                             |
      | fromBillingZone.l3_name             | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[1].l3Name}                           |
      | toBillingZone.billingZone           | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].billingZone}                      |
      | toBillingZone.latitude              | <toLatitude>                                                            |
      | toBillingZone.longitude             | <toLongitude>                                                           |
      | toBillingZone.l1_id                 | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].l1Id}                             |
      | toBillingZone.l1_name               | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].l1Name}                           |
      | toBillingZone.l2_id                 | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].l2Id}                             |
      | toBillingZone.l2_name               | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].l2Name}                           |
      | toBillingZone.l3_id                 | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].l3Id}                             |
      | toBillingZone.l3_name               | {KEY_SORT_LIST_OF_FOUND_ZONES_INFO[2].l3Name}                           |

    Examples:
      | fromLatitude     | fromLongitude   | toLatitude | toLongitude |
      | 1.31238520693375 | 103.88610372481 | 1.3880089  | 103.8946339 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op