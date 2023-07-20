Feature: Cancel RTS

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Cancel RTS For Routed Marketplace Sort Order via Edit Order Page (uid:7b95e8ec-e000-4c2b-93ae-d62063c3dd4d)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                             |
      | bottom | ^.*Error Message: Marketplace Sort Order not allowed to revert RTS while routed.* |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id

    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies route_monitoring_data record

  Scenario: Operator Cancel RTS For Unrouted Marketplace Sort Order via Edit Order Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | The RTS has been cancelled |
      | waitUntilInvisible | true                       |
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is Rts changed from true to false |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                      |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And Operator verifies Delivery Details on Edit Order Page:
      | toName     | Elsa Sender      |
      | toEmail    | elsaf@ninja.com  |
      | toContact  | +6583014912      |
      | toAddress1 | 9 TUA KONG GREEN |
      | toPostcode | 455384           |
    And DB Operator verifies orders record using data below:
      | rts | 0 |
    And DB Operator verifies orders record using data below:
      | toAddress1 | 9 TUA KONG GREEN |
      | toAddress2 |                  |
      | toPostcode | 455384           |
      | toCity     |                  |
      | toCountry  | SG               |
      | toState    |                  |
      | toName     | Elsa Sender      |
      | toEmail    | elsaf@ninja.com  |
      | toContact  | +6583014912      |
      | toDistrict |                  |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | city       | null                               |
      | country    | SG                                 |
      | name       | Elsa Sender                        |
      | email      | elsaf@ninja.com                    |
      | contact    | +6583014912                        |
    And DB Operator verifies waypoints record:
      | id            | {KEY_TRANSACTION_AFTER.waypointId} |
      | address1      | 9 TUA KONG GREEN                   |
      | address2      | null                               |
      | postcode      | 455384                             |
      | city          | null                               |
      | country       | SG                                 |
      | latitude      | 1.3184395712682                    |
      | longitude     | 103.925311276846                   |
      | routingZoneId | 22861                              |

  @DeleteOrArchiveRoute
  Scenario: Do not Allow Cancel RTS for Marketplace Sort Order (uid:2334f294-1959-4add-8278-a6c3b2a55e29)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                             |
      | bottom | ^.*Error Message: Marketplace Sort Order not allowed to revert RTS while routed.* |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Return to Sender -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | The RTS has been cancelled |
      | waitUntilInvisible | true                       |
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE AV |
    And DB Operator verifies orders record using data below:
      | rts | 0 |

  Scenario: Operator Cancel RTS from Edit Order Page (uid:d4419364-fa79-41db-8b2f-2367864463fb)
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    And API Operator delete or archive created route
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | The RTS has been cancelled |
      | waitUntilInvisible | true                       |
    Then Operator refresh page
    And API Operator get order details
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                 |
      | description | To Address 1 changed from 233E ST. JOHN'S ROAD to 9 TUA KONG GREEN To Postcode changed from 757995 to 455384 Is Rts changed from true to false |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                      |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And Operator verifies Delivery Details on Edit Order Page:
      | toName     | Elsa Sender      |
      | toEmail    | elsaf@ninja.com  |
      | toContact  | +6583014912      |
      | toAddress1 | 9 TUA KONG GREEN |
      | toPostcode | 455384           |
    And DB Operator verifies orders record using data below:
      | rts | 0 |
    And DB Operator verifies orders record using data below:
      | toAddress1 | 9 TUA KONG GREEN |
      | toAddress2 |                  |
      | toPostcode | 455384           |
      | toCity     |                  |
      | toCountry  | SG               |
      | toState    |                  |
      | toName     | Elsa Sender      |
      | toEmail    | elsaf@ninja.com  |
      | toContact  | +6583014912      |
      | toDistrict |                  |
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | city       | null                               |
      | country    | SG                                 |
      | name       | Elsa Sender                        |
      | email      | elsaf@ninja.com                    |
      | contact    | +6583014912                        |
    And DB Operator verifies waypoints record:
      | id            | {KEY_TRANSACTION_AFTER.waypointId} |
      | address1      | 9 TUA KONG GREEN                   |
      | address2      | null                               |
      | postcode      | 455384                             |
      | city          | null                               |
      | country       | SG                                 |
      | latitude      | 1.3184395712682                    |
      | longitude     | 103.925311276846                   |
      | routingZoneId | 22861                              |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op