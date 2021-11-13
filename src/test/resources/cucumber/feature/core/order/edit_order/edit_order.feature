@OperatorV2 @Core @Order @EditOrder
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Edit Pickup Details on Edit Order page (uid:bde3592e-843f-4a99-9a60-66c46c4b257c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Edit Pickup Details on Edit Order page
    And Operator update Pickup Details on Edit Order Page
      | senderName     | test sender name                       |
      | senderContact  | +9727894434                            |
      | senderEmail    | test@mail.com                          |
      | internalNotes  | test internalNotes                     |
      | pickupDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | pickupTimeslot | 9AM - 12PM                             |
      | country        | Singapore                              |
      | city           | Singapore                              |
      | address1       | 116 Keng Lee Rd                        |
      | address2       | 15                                     |
      | postalCode     | 308402                                 |
    Then Operator verify Pickup "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Pickup "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Pickup "UPDATE SLA" order event description on Edit order page
    And Operator verifies Pickup Details are updated on Edit Order Page
    And Operator verifies Pickup Transaction is updated on Edit Order Page
    And DB Operator verifies pickup info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 17 |
      | 11 |
      | 12 |
    And DB Operator verify Pickup '17' order_events record for the created order
    And DB Operator verify Pickup transaction record is updated for the created order
    And DB Operator verify Pickup waypoint record is updated

  Scenario: Operator Edit Delivery Details on Edit Order page (uid:e17ae476-5ccb-436e-b256-21ab3443a2ee)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And API Operator get order details
    And Operator update Delivery Details on Edit Order Page
      | recipientName    | test sender name                       |
      | recipientContact | +9727894434                            |
      | recipientEmail   | test@mail.com                          |
      | internalNotes    | test internalNotes                     |
      | deliveryDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | deliveryTimeslot | 9AM - 12PM                             |
      | country          | Singapore                              |
      | city             | Singapore                              |
      | address1         | 116 Keng Lee Rd                        |
      | address2         | 15                                     |
      | postalCode       | 308402                                 |
    Then Operator verifies that success toast displayed:
      | top                | Delivery Details Updated |
      | waitUntilInvisible | true                     |
    Then Operator verify Delivery "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Delivery "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Delivery "UPDATE SLA" order event description on Edit order page
    And Operator verifies Delivery Details are updated on Edit Order Page
    And Operator verifies Delivery Transaction is updated on Edit Order Page
    And DB Operator verifies delivery info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 17 |
      | 11 |
      | 12 |
    And DB Operator verify Delivery '17' order_events record for the created order
    And DB Operator verify Delivery transaction record of order "KEY_CREATED_ORDER_ID":
      | address1  | {KEY_CREATED_ORDER.toAddress1}                  |
      | address2  | {KEY_CREATED_ORDER.toAddress2}                  |
      | postcode  | {KEY_CREATED_ORDER.toPostcode}                  |
      | city      | {KEY_CREATED_ORDER.toCity}                      |
      | country   | {KEY_CREATED_ORDER.toCountry}                   |
      | name      | {KEY_CREATED_ORDER.toName}                      |
      | email     | {KEY_CREATED_ORDER.toEmail}                     |
      | contact   | {KEY_CREATED_ORDER.toContact}                   |
      | startTime | {gradle-next-2-working-day-yyyy-MM-dd} 09:00:00 |
      | endTime   | {gradle-next-4-working-day-yyyy-MM-dd} 12:00:00 |
    And DB Operator verify Delivery waypoint record is updated

  Scenario: Operator Tag Order to DP (uid:b6540556-8969-4519-9716-f273a96db356)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | ASSIGNED TO DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When DB Operator get DP address by ID = "{dpms-id}"
    Then DB Operator verifies orders record using data below:
      | toAddress1 | GET_FROM_CREATED_ORDER |
      | toAddress2 | GET_FROM_CREATED_ORDER |
      | toPostcode | GET_FROM_CREATED_ORDER |
      | toCity     | GET_FROM_CREATED_ORDER |
      | toCountry  | GET_FROM_CREATED_ORDER |
      | toState    |                        |
      | toDistrict |                        |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | {dpms-id}              |
      | address1              | GET_FROM_CREATED_ORDER |
      | address2              | GET_FROM_CREATED_ORDER |
      | postcode              | GET_FROM_CREATED_ORDER |
      | city                  | GET_FROM_CREATED_ORDER |
      | country               | GET_FROM_CREATED_ORDER |
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 18 |

  Scenario: Operator Untag/Remove Order from DP (uid:cc4e3098-6bdd-48ea-9488-579535af8722)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | 0                      |
      | address1              | GET_FROM_CREATED_ORDER |
      | address2              | GET_FROM_CREATED_ORDER |
      | postcode              | GET_FROM_CREATED_ORDER |
      | city                  | GET_FROM_CREATED_ORDER |
      | country               | GET_FROM_CREATED_ORDER |
    And DB Operator verifies delivery info is updated in order record
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 35 |

  Scenario: Operator Edit Instructions of an Order on Edit Order Page (uid:a5de8db3-f5a2-4bda-8984-96794753d26c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator click Order Settings -> Edit Instructions on Edit Order page
    When Operator enter Order Instructions on Edit Order page:
      | pickupInstruction   | new pickup instruction   |
      | deliveryInstruction | new delivery instruction |
    When Operator verify Order Instructions are updated on Edit Order Page
    And DB Operator verify order_events record for the created order:
      | type | 14 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE INSTRUCTION |

  Scenario: Operator Edit Priority Level (uid:849b151c-967b-4a20-afba-73fc9334570d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Priority Level to "2" on Edit Order page
    Then Operator verify Delivery Priority Level is "2" on Edit Order page
    And DB Operator verify next Delivery transaction values are updated for the created order:
      | priorityLevel | 2 |
    And DB Operator verify next Pickup transaction values are updated for the created order:
      | priorityLevel | 0 |
    And DB Operator verify order_events record for the created order:
      | type | 17 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE SLA |

  Scenario: Operator Edit Order Details on Edit Order page (uid:1884a911-4599-4faa-8d63-a9b984f1c989)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page
    Then Operator Edit Order Details on Edit Order page successfully

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
    And Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Edit Cash Collection Details - Update Cash on Delivery (uid:c747a488-2545-4cba-8982-f148bffd3c57)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And Operator verify "UPDATE CASH" order event description on Edit order page
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
    Then Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Edit Cash Collection Details - Remove Cash on Delivery (uid:6da65f1f-b866-424f-8cf3-2e4a982c9191)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to no
    And Operator refresh page
    Then Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Operator Delete Order - Status = Pending Pickup (uid:6364a910-2590-4a04-adf1-368a9b789b3e)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Order - Status = Van en-route to Pickup (uid:dcb07b88-ecda-4b51-85c1-381b3ff898e9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to Pickup" on Edit Order page
    When Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted

  Scenario: Operator Delete Order - Status = Staging (uid:9b41fbd7-7079-49d9-81c6-81505e5ffd2c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Staging" on Edit Order page
    And Operator verify order granular status is "Staging" on Edit Order page
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted

  @DeleteOrArchiveRoute
  Scenario: Operator Delete Order - Status = Pickup Fail (uid:1ea40765-c2f6-4d5e-9847-6d17a7921eab)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted

  Scenario: Operator Print the Airway Bill On Edit Order Page (uid:e017c4ea-2015-420d-a86e-a884ffbf89e0)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Pull Out Parcel from a Route - PICKUP (uid:c6ab425f-c508-451f-b84c-09eb267c5f27)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been pulled from route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                           |
    Then Operator verify Pickup transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Pull Out Parcel from a Route - DELIVERY (uid:91bf2923-94ba-4d8c-bd1b-c000eca19ee9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator start the route
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been pulled from route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                           |
    Then Operator verify Delivery transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies waypoint for Delivery transaction is deleted from route_waypoint table
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted

  @DeleteOrArchiveRoute @routing-refactor
  Scenario Outline: Operator Add to Route on Pickup Menu Edit Order Page - <Note> (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order to the <routeType> route on Edit Order page
    Then Operator verifies that info toast displayed:
      | top | {KEY_CREATED_ORDER_TRACKING_ID} has been added to route {KEY_CREATED_ROUTE_ID} successfully |
    And Operator refresh page
    Then Operator verify the order is added to the <routeType> route on Edit Order page
    Then Operator verify Latest Route ID is "{KEY_CREATED_ROUTE_ID}" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE         |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify <routeType> waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies waypoints.seq_no is the same as route_waypoint.seq_no for each waypoint
    And DB Operator verifies route_monitoring_data record
    Examples:
      | Note              | hiptest-uid                              | orderType | routeType |
      | Return - Delivery | uid:ce190fcf-c0d5-47ad-9777-0296edecc8c2 | Return    | Delivery  |
      | Return - Pickup   | uid:0c1c44ce-9fce-46e7-9016-f73613eef833 | Return    | Pickup    |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Pickup (uid:c1962397-8060-4485-9221-47cb46803ddf)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail pickup waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Pickup on Edit Order Page
      | senderName     | test sender name          |
      | senderContact  | +9727894434               |
      | senderEmail    | test@mail.com             |
      | internalNotes  | test internalNotes        |
      | pickupDate     | {{next-1-day-yyyy-MM-dd}} |
      | pickupTimeslot | 9AM - 12PM                |
      | country        | Singapore                 |
      | city           | Singapore                 |
      | address1       | 116 Keng Lee Rd           |
      | address2       | 15                        |
      | postalCode     | 308402                    |
    Then DB Operator verifies pickup info is updated in order record
    And DB Operator verify Pickup waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And DB Operator verifies transactions after reschedule pickup
      | old_pickup_status | Fail    |
      | new_pickup_status | Pending |
      | new_pickup_type   | PP      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery (uid:af4f96cb-5ed1-4035-8a29-650ac5013aae)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail delivery waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then DB Operator verifies delivery info is updated in order record
    And DB Operator verify Delivery waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And DB Operator verifies transactions after reschedule
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Hub Inbound Scan (uid:6a7a2f76-f033-4637-b2e0-e1973d080026)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies transactions after reschedule
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Driver Inbound Scan (uid:066c5598-129c-4fe0-bd9a-0af449703f33)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESCHEDULE |
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies transactions after reschedule
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with New Stamp ID (uid:ce1f0e4d-435e-4467-ab58-76019c30f8a4)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    Then Operator verify next order info on Edit order page:
      | stampId | KEY_STAMP_ID |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |
    And Operator switch to Edit Order's window

  Scenario: Update Stamp ID - Update Stamp ID with Stamp ID that Have been Used Before (uid:e43837c6-311c-40c7-9a7b-08d47253ecf9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And DB Core Operator gets order with Stamp ID
    Then Operator unable to change Stamp ID of the created order to "KEY_LAST_STAMP_ID" on Edit order page
    And Operator refresh page
    Then Operator verify next order info on Edit order page:
      | stampId | - |

  Scenario: Update Stamp ID - Update Stamp ID with Another Order's Tracking ID (uid:f80d5aa7-c010-4855-b405-32c478cb5eb1)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And DB Core Operator gets random trackingId
    Then Operator unable to change Stamp ID of the created order to "KEY_ANOTHER_ORDER_TRACKING_ID" on Edit order page
    When Operator refresh page
    Then Operator verify next order info on Edit order page:
      | stampId | - |

  Scenario: Remove Stamp ID (uid:70f0c0e4-1331-4a92-911e-ca6ac132377c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    And Operator remove Stamp ID of the created order on Edit order page
    Then Operator verify next order info on Edit order page:
      | stampId | - |
    When Operator go to menu Order -> All Orders
    Then Operator can't find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |

  Scenario Outline: Operator Change Delivery Verification Method from Edit Order - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"<delivery_verification_mode>","is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator set Delivery Verification Required to "<new_delivery_verification_mode>" on on Edit order page
    Then Operator verify Delivery Verification Required is "<new_delivery_verification_mode>" on on Edit order page
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE DELIVERY VERIFICATION |
    When DB Operator get shipper ref metadata of created order
    Then DB Operator make sure shipper ref metadata contains values:
      | deliveryVerificationMode | <new_delivery_verification_mode> |
    When DB Operator get order delivery verifications of created order
    Then DB Operator make sure order delivery verifications contains values:
      | deliveryVerificationMode | <new_delivery_verification_mode> |

    Examples:
      | Note        | delivery_verification_mode | new_delivery_verification_mode | hiptest-uid                              |
      | OTP to NONE | OTP                        | None                           | uid:faa86019-64a6-4755-aa51-252d4fe2dc38 |
      | NONE to OTP | NONE                       | OTP                            | uid:f4cda665-1173-49a8-83ec-e261e69ae554 |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario Outline: Operator Add to Route on Delivery Menu Edit Order Page - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order route on Edit Order page using data below:
      | type    | Delivery               |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies that info toast displayed:
      | top | {KEY_CREATED_ORDER_TRACKING_ID} has been added to route {KEY_CREATED_ROUTE_ID} successfully |
    When Operator refresh page
    Then Operator verify Latest Route ID is "{KEY_CREATED_ROUTE_ID}" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE         |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies waypoints.seq_no is the same as route_waypoint.seq_no for each waypoint
    And DB Operator verifies route_monitoring_data record

    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:9d63adef-503f-48af-9232-c2a003c5240e | Normal    |
      | Return | uid:75222ea2-43c3-4783-9b1c-bed9a999f45e | Return    |

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

  @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Unrouted (uid:2ce27a02-460b-40f3-91f4-e42981a6eb96)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn   | 2       |
      | delivery_status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed (uid:d66b5b2a-a59e-4e74-b001-5605489da68a)
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Pending Reschedule, Latest Scan = Driver Inbound Scan (uid:d56ee23a-ca14-4d91-9942-4ae1c71a49b9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | DRIVER INBOUND SCAN        |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Pending Reschedule, Latest Scan = Hub Inbound Scan (uid:5bae8c76-b67d-4cfd-9d7e-2af0d0fe0db9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
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
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | HUB INBOUND SCAN           |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Suggest Route on Edit Order Page - Delivery, Suggested Route Found (uid:9df8ffd8-1adb-4752-9769-14d3d03393ff)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Delivery -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verify Route value is "{KEY_CREATED_ROUTE_ID}" in Add To Route dialog on Edit Order Page

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Suggest Route on Edit Order Page - Pickup, Suggested Route Found (uid:236f2423-0404-4db1-a4aa-79ef4ed3655f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Pickup -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verify Route value is "{KEY_CREATED_ROUTE_ID}" in Add To Route dialog on Edit Order Page

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Suggest Route on Edit Order Page - Delivery, No Suggested Route Found (uid:4fc900dd-1ce2-4362-801c-63c2053ac0d1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Delivery -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    And Operator verify Route value is "" in Add To Route dialog on Edit Order Page

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Suggest Route on Edit Order Page - Pickup, No Suggested Route Found (uid:c3b9d6c1-c600-4d0d-aa24-c06476e2e32b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-current-date-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-current-date-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    And Operator click Pickup -> Add To Route on Edit Order page
    And Operator suggest route of "{KEY_CREATED_ROUTE_TAG.name}" tag from the Route Finder on Edit Order Page
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    And Operator verify Route value is "" in Add To Route dialog on Edit Order Page

  @routing-refactor
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Pickup Cancelled, Delivery Cancelled (uid:849dfc99-3ee7-4e7d-a665-bbfec8396ff3)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status to = "Cancelled"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  @DeleteOrArchiveRoute
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Return Pickup Fail With Waypoint (uid:56dd7c4f-e5a3-4e7e-93b4-0f29a9caa4f6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Driver failed the C2C/Return order pickup
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  Scenario: Operator Resume a Cancelled Order on Edit Order page - Return Pickup Fail With NO Waypoint (uid:6086ccbe-01f6-4d6b-bcb6-a0f5f420dd4b)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status to = "Pickup Fail"
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  Scenario: Operator Resume a Cancelled Order on Edit Order page - Normal Pickup Fail (uid:013d274e-ed52-4026-be99-ffe8707268ea)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status to = "Pickup Fail"
    And API Operator cancel created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  @DeleteOrArchiveRoute
  Scenario: Operator View POD from Edit Order Page (uid:87f02736-7ccf-4d62-a3e3-fd81636a36ab)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver all created parcels successfully
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> View all PODs on Edit Order page
    Then Operator verify delivery POD details is correct on Edit Order page using date below:
      | driver              | {ninja-driver-username} |
      | verification method | NO_VERIFICATION         |

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

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Untag DP Order that is merged and routed (uid:77fec425-2a5b-4667-b82f-b6394caec5d5)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign delivery multiple waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator merge route transactions
    Then API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    Then DB Operator verifies all route_waypoint records
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies all route_monitoring_data records

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Untag DP Order that is not merged and routed (uid:2c86a0e4-480f-4361-90e5-0be6628c90cb)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign delivery multiple waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    Then DB Operator verifies all route_waypoint records
    And DB Operator verifies all waypoints status is "ROUTED"
    And DB Operator verifies all waypoints.route_id & seq_no is populated correctly
    And DB Operator verifies first & last waypoints.seq_no are dummy waypoints
    And DB Operator verifies all route_monitoring_data records

  @routing-refactor
  Scenario: Untag DP Order that is merged and not routed (uid:cea0056a-d4e8-4d54-8b7d-28fc786ee3db)
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator assign delivery multiple waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And Operator get multiple "DELIVERY" transactions with status "PENDING"
    And Operator merge transactions on Zonal Routing
    Then API Operator verifies Delivery transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    When Operator get multiple "DELIVERY" transactions with status "PENDING"
    Then DB Operator verifies all waypoints status is "PENDING"
    And DB Operator verifies all waypoints.route_id & seq_no is NULL

  @DeleteOrArchiveRoute
  Scenario: Operator Add Marketplace Sort Order To Route via Edit Order Page - RTS = 1 (uid:4cf017ce-642e-4f98-95be-674bd0305f17)
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
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order route on Edit Order page using data below:
      | menu    | Return to Sender       |
      | type    | Delivery               |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies that info toast displayed:
      | top                | {KEY_CREATED_ORDER_TRACKING_ID} has been added to route {KEY_CREATED_ROUTE_ID} successfully |
      | waitUntilInvisible | true                                                                                        |
    And API Operator get order details
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies route_monitoring_data record

  @DeleteOrArchiveRoute
  Scenario: Operator Add Marketplace Sort Order To Route via Edit Order Page - RTS = 0 (uid:12de41cd-ba4d-4303-9c49-c1ec9b15a04e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order route on Edit Order page using data below:
      | type    | Delivery               |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                          |
      | bottom | ^.*Error Code: 103093.*Error Message: Marketplace Sort order is not allowed!.* |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null

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

  Scenario: Resume Pickup For On Hold Order (uid:75e59db9-3f68-4979-8cde-493cb766d524)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Recovery -> Recovery Tickets
    And Operator create new ticket on page Recovery Tickets using data below:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE STATUS |
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED      |
      | outcome | RESUME PICKUP |
    And Operator refresh page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name            |
      | UPDATE STATUS   |
      | RESUME PICKUP   |
      | TICKET UPDATED  |
      | TICKET RESOLVED |

  @DeleteOrArchiveRoute
  Scenario: Operator Create Recovery Ticket For Return Pickup (uid:a0dc605d-7a22-43db-929c-d38311720b52)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van en-route to Pickup" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    When Operator create new recovery ticket on Edit Order page:
      | entrySource                   | CUSTOMER COMPLAINT |
      | investigatingDepartment       | Recovery           |
      | investigatingHub              | {hub-name}         |
      | ticketType                    | PARCEL EXCEPTION   |
      | ticketSubType                 | INACCURATE ADDRESS |
      | orderOutcomeInaccurateAddress | RESUME DELIVERY    |
      | custZendeskId                 | 1                  |
      | shipperZendeskId              | 1                  |
      | ticketNotes                   | GENERATED          |
    When Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify order events on Edit order page using data below:
      | name           |
      | TICKET CREATED |
      | UPDATE STATUS  |
      | RESCHEDULE     |
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP |
      | status | FAIL   |
    And Operator verify transaction on Edit order page using data below:
      | type   | PICKUP  |
      | status | PENDING |
    And Operator verify transaction on Edit order page using data below:
      | type   | DELIVERY |
      | status | PENDING  |

  @DeleteOrArchiveRoute
  Scenario: Operator Reverify Order Address in Edit Order Page (uid:4021b29d-4ddf-4cd8-9141-b56f1e0fa6c0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Reverify Delivery Address on Edit Order page
    And Operator verifies that info toast displayed:
      | top | Reverified Successfully |
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order:
      | archived | score |
      | 1        | 1.0   |
      | 0        | 0.5   |

  @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Parcel from a Route - PICKUP - Route is Soft Deleted (uid:ea35eba9-818c-4a84-a4c5-bb884bd1ba91)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | {"service_type":"Return","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Pickup on Edit Order page
    And Operator refresh page
    Then Operator verify order events on Edit order page using data below:
      | name              |
      | PULL OUT OF ROUTE |
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted
    And DB Operator verifies waypoint status is "PENDING"

  @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Parcel from a Route - DELIVERY - Route is Soft Deleted (uid:a3346fd5-8f4f-40c6-98f1-5fd172a2261c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    And Operator refresh page
    Then Operator verify order events on Edit order page using data below:
      | name              |
      | PULL OUT OF ROUTE |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted
    And DB Operator verifies waypoint status is "PENDING"

  @DeleteOrArchiveRoute
  Scenario: Operator Resume a Cancelled Order on Edit Order page - Delivery is Not Cancelled (uid:9f299d69-54b1-4049-93ee-bc9bdaf50476)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator force cancels the created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    When Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |
    When API Operator get order details
    Then DB Operator verify Pickup waypoint of the created order using data below:
      | status | Pending |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | Fail |

  Scenario: Operator Resume an Order on Edit Order page - Non-Cancelled Order (uid:d55ff55e-4422-4e41-b836-aed757f72dc4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verify menu item "Order Settings" > "Resume Order" is disabled on Edit order page
    When API Operator resume the created order
    And Operator refresh page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op