@Sort @Utilities @BulkAddressVerificationPart2
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk AV RTS orders - Empty Waypoint ID
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method | waypoint                                                   | toAddress1                                 | latitude  | longitude |
      | EMPTY  | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | GENERATED | GENERATED |
      | EMPTY  | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | GENERATED | GENERATED |
      | EMPTY  | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | GENERATED | GENERATED |
      | EMPTY  | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | GENERATED | GENERATED |
      | EMPTY  | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | GENERATED | GENERATED |

  Scenario: Bulk AV RTS orders - Valid and Empty Waypoint ID
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
   And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[5].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[5] |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude        | longitude       |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | EMPTY                      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[2].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[3].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[3].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | EMPTY                      | {KEY_LIST_OF_CREATED_ORDERS[4].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[4].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[5].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[5].toAddress1} | FROM_CONFIG_RTS | FROM_CONFIG_RTS |
    And Operator verifies waypoints are assigned to "RTS" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[3].id}"
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[5].id}"

  Scenario: Download Bulk AV Sample CSV File
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator download sample CSV file on Bulk Address Verification page
    Then sample CSV file on Bulk Address Verification page is downloaded successfully

  Scenario Outline: ID - Populate Pricing Info with Address Billing Zone L1-L3 upon Bulk Address Verification
    Given API Sort - Operator get Billing Zone info:
      | latitude       | longitude       |
      | <fromLatitude> | <fromLongitude> |
      | <toLatitude>   | <toLongitude>   |
    And API Order - Shipper create multiple V4 orders using data below:
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","from":{"name": "binti v4.1 ID","phone_number":"+6281386061359","email":"customer.return.kuc8tny9@ninjavan.co","address": {"contact": "+6598980057","email": "address.sg.6598980000@ninjavan.co","address1": "34 LORONG 30 GEYLANG","address2": "1-1","postcode": "10120","country": "ID","city": "SG","state": "Singapore","sub_district": "sub district","district": "district","street": "Street","latitude":<fromLatitude>,"longitude":<fromLongitude>}},"to":{"name":"George Ezra","phone_number":"+6281386061359","email":"address.sg.6598980000@ninjavan.co","address":{"contact": "+6598980001","email": "address.sg.6598980000@ninjavan.co","address1": "8 MARINA BOULEVARD","address2": "#01-01","postcode": "10120","country": "id","city": "SG","state": "Singapore","sub_district":"sub district","district":"district","street":"Marina St","latitude":<toLatitude>,"longitude":<toLongitude>}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"09:00", "end_time":"12:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"18:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator upload bulk address CSV using data below:
      | order      | {KEY_LIST_OF_CREATED_ORDERS[1]}                            |
      | method     | FROM_CREATED_ORDER_DETAILS                                 |
      | waypoint   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | latitude   | <toLatitude>                                               |
      | longitude  | <toLongitude>                                              |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Then Operator verify pricing info of order with:
      | expectedfromBillingZone.billingZone | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.billingZone} |
      | expectedfromBillingZone.latitude    | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.latitude}    |
      | expectedfromBillingZone.longitude   | {KEY_LIST_OF_CREATED_ORDERS[1].pricingInfo.fromBillingZone.longitude}   |
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
      | fromLatitude | fromLongitude | toLatitude | toLongitude |
      | -6.035939    | 106.843739    | -8.0021898 | 110.503534  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op