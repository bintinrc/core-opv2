@OperatorV2 @Core @Order @EditOrder @CancelRTS
Feature: Cancel RTS

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Cancel RTS from Edit Order Page (uid:d4419364-fa79-41db-8b2f-2367864463fb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver failed the delivery of the created parcel
    And API Operator delete or archive created route
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | The RTS has been cancelled |
      | waitUntilInvisible | true                       |
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order page
    And Operator verifies Latest Event is "REVERT RTS" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And DB Operator verifies orders record using data below:
      | rts | 0 |

  @DeleteOrArchiveRoute
  Scenario: Operator Cancel RTS For Routed Marketplace Sort Order via Edit Order Page (uid:7b95e8ec-e000-4c2b-93ae-d62063c3dd4d)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies route_monitoring_data record

  Scenario: Operator Cancel RTS For Unrouted Marketplace Sort Order via Edit Order Page (uid:40ce5b0f-8d71-42f9-af4d-08b0c8c25f52)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | The RTS has been cancelled |
      | waitUntilInvisible | true                       |
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order page
    And Operator verifies Latest Event is "REVERT RTS" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And DB Operator verifies orders record using data below:
      | rts | 0 |

  @DeleteOrArchiveRoute
  Scenario: Do not Allow Cancel RTS for Marketplace Sort Order (uid:2334f294-1959-4add-8278-a6c3b2a55e29)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator verifies Latest Event is "REVERT RTS" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And DB Operator verifies orders record using data below:
      | rts | 0 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op