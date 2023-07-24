#@OperatorV2 @Core @EditOrder @CashCollection @EditOrder2
Feature: Cash Collection

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Edit Cash Collection Details - Add Cash on Pickup (uid:f38119f4-8baf-48bc-ad02-8d0d98a8cd03)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Pickup toggle to yes
    And Operator change the COP value to "100"
    And Operator refresh page
    Then Operator verify COP value is updated to "100"
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  @happy-path
  Scenario: Edit Cash Collection Details - Add Cash on Delivery (uid:a1290675-50c1-4c63-b371-3af1f2b61e22)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to yes
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Edit Cash Collection Details - Update Cash on Pickup (uid:24a93b3a-11be-4488-820e-fb055ecef040)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change the COP value to "100"
    And Operator refresh page
    Then Operator verify COP value is updated to "100"
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CASH                            |
      | description | Cash On Pickup changed from 23.57 to 1 |
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  @happy-path
  Scenario: Edit Cash Collection Details - Update Cash on Delivery (uid:c747a488-2545-4cba-8982-f148bffd3c57)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CASH                              |
      | description | Cash On Delivery changed from 23.57 to 1 |
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Edit Cash Collection Details - Remove Cash on Pickup (uid:998f5cfa-c712-4dcd-b3a0-e06bf8f4fd13)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Pickup toggle to no
    And Operator refresh page
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CASH                            |
      | description | Cash On Pickup changed from 23.57 to 0 |
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  @happy-path
  Scenario: Edit Cash Collection Details - Remove Cash on Delivery (uid:6da65f1f-b866-424f-8cf3-2e4a982c9191)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to no
    And Operator refresh page
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CASH                              |
      | description | Cash On Delivery changed from 23.57 to 0 |
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Disable Update Cash Button if Order State is Completed (uid:24a943e1-adbd-49ef-89a8-7ef1de370441)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order with cod
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit order page

  Scenario: Disable Update Cash Button if Order State is Returned to Sender (uid:a8496456-76ca-41eb-9f9b-583e92627f58)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator force succeed created order without cod
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit order page

  @DeleteOrArchiveRoute
  Scenario: Disable Update Cash Button if Order State is On Vehicle for Delivery (uid:d1b2a183-0932-4c41-a920-18f7bc08cb5a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify menu item "Order Settings" > "Edit Cash Collection Details" is disabled on Edit order page
