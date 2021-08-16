@OperatorV2 @Core @Order @AllOrders
Feature: All Orders

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Resume Selected Cancelled Order on All Orders Page - Single Order (uid:9c22866c-b910-4834-a050-347552d4a801)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator go to menu Order -> All Orders
    When Operator resume order on All Orders page
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
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
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  Scenario: Operator Resume Selected Cancelled Order on All Orders Page - Multiple Orders (uid:07ae3956-3711-4994-8de4-94d43ca93edf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created orders
    And Operator go to menu Order -> All Orders
    When Operator resume multiple orders on All Orders page
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
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
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
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
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  Scenario: Operator Cancel Multiple Orders on All Orders Page (uid:075f601c-dea6-4967-9eaf-f65d95ab6e7a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator cancel multiple orders on All Orders page
    Then API Operator verify multiple orders info after Canceled

  @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Multiple Orders from Route on All Orders Page (uid:20af0f30-6144-42a9-9833-adcdf0baca15)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator pull out multiple orders from route on All Orders page
    Then API Operator verify multiple orders is pulled out from route

  @DeleteOrArchiveRoute
  Scenario: Operator Add Multiple Orders to Route on All Orders Page (uid:1e20a4ff-0254-47c8-8453-948097da2946)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator add multiple orders to route on All Orders page:
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies that info toast displayed:
      | top    | 3 order(s) updated |
      | bottom | add to route       |
    And API Operator verify multiple delivery orders is added to route

  Scenario: Operator Print Waybill for Single Order on All Orders Page and Verify the Downloaded PDF Contains Correct Info (uid:4989c98b-9a7d-4f87-8bc3-d7b3692ce279)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify the printed waybill for single order on All Orders page contains correct info

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Add Parcel to Route Using Tag Filter on All Orders Page (uid:a5f2f56b-2484-4401-bb65-f713c85e6017)
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
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator add multiple orders to route on All Orders page:
      | trackingIds | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]},{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | tag         | {KEY_CREATED_ROUTE_TAG.name}                                                          |
    Then Operator verifies that info toast displayed:
      | top    | 2 order(s) updated |
      | bottom | add to route       |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |

  Scenario: Operator Force Success Order on All Orders Page - End State = Completed (uid:0fa34155-b840-45c0-95eb-a789526c6e26)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page
    Then API Operator verify order info after Force Successed
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |

  Scenario: Operator Force Success Multiple Orders on All Orders Page (uid:07e813db-12db-4861-a27f-f5a059f186af)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success multiple orders on All Orders page
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |

  Scenario: Operator Should not be Able to Pull Out Unrouted Order on All Orders Page (uid:3bc0f4f3-ccfa-4f2e-93a2-126956a73186)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Order -> All Orders
    And Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator apply "Pull From Route" action and expect to see "Selection Error"
    Then Operator verify Selection Error dialog for invalid Pull From Order action

  @DeleteOrArchiveRoute
  Scenario: Operator RTS Failed Delivery Order on All Orders Page (uid:babc6862-40c1-45d4-a626-f0ebf5d0cbf9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator RTS single order on next day on All Orders page
    Then API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day

  @DeleteOrArchiveRoute
  Scenario: Operator RTS Multiple Orders on All Orders Page (uid:0061ef8a-2496-4ed9-a259-4dd01e8c7cba)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    And Operator RTS multiple orders on next day on All Orders page
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name | RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
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
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name | RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
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

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Delivery, Suggested Route Found for All Waypoints (uid:b9215b2a-4ef6-4076-a3f1-6fabeec16c9c)
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
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | tag | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId                |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | {KEY_CREATED_ROUTE_ID} |

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Delivery, Suggested Route Found for Partial Waypoint (uid:0319ce57-7d5d-4d0f-b02e-9cb682e070e0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    #Create Order and add to route
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
    #Create Order with same address
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    #Create Order with different address
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    #Create another route tag
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator suggest routes on Add Selected to Route form:
      | trackingId                                 | type     | tag                                      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Delivery | {KEY_LIST_OF_CREATED_ROUTE_TAGS[1].name} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Delivery | {KEY_LIST_OF_CREATED_ROUTE_TAGS[2].name} |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId                |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |                        |

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Delivery, No Suggested Route Found (uid:483e367c-927f-4c72-8679-9cc3badf06ec)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | generateTo     | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | type | Delivery                     |
      | tag  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         |

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Pickup, Suggested Route Found for All Waypoints (uid:1f7eb099-3337-45dc-a8d5-30e2dd92f954)
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
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                      |
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | type | Pickup                       |
      | tag  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId                |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | {KEY_CREATED_ROUTE_ID} |

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Pickup, Suggested Route Found for Partial Waypoint (uid:fc3ae755-e9e2-4f44-98ab-626c4af6594a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    #Create Order and add to route
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
    #Create Order with same address
    And API Shipper create V4 order using data below:
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    #Create Order with different address
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    #Create another route tag
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
    When Operator suggest routes on Add Selected to Route form:
      | trackingId                                 | type   | tag                                      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Pickup | {KEY_LIST_OF_CREATED_ROUTE_TAGS[1].name} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Pickup | {KEY_LIST_OF_CREATED_ROUTE_TAGS[2].name} |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId                |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | {KEY_CREATED_ROUTE_ID} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |                        |

  @DeleteOrArchiveRoute @DeleteRouteTags
  Scenario: Operator Bulk Suggest Route on Multiple Orders from All Orders Page - Pickup, No Suggested Route Found (uid:06e5d86f-adf3-4a4f-8fa6-e998185449f9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                      |
      | generateFrom   | ZONE {zone-name-3}                                                                                                                                                                                                                                                                                                                     |
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-current-date-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"09:00", "end_time":"22:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-3}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{gradle-previous-1-day-yyyy-MM-dd} 16:00:00", "dateTime": "{gradle-previous-1-day-yyyy-MM-dd}T16:00:00+00:00" } |
    And API Operator create new route tag:
      | name        | GENERATED                          |
      | description | tag for automated testing purposes |
    And API Operator set tags of the new created route to [{KEY_CREATED_ROUTE_TAG.id}]
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator suggest routes on Add Selected to Route form using Set To All:
      | type | Pickup                       |
      | tag  | {KEY_CREATED_ROUTE_TAG.name} |
    Then Operator verifies that error toast displayed:
      | top    | Error trying to suggest route            |
      | bottom | No waypoints to suggest after filtering! |
    Then Operator verify Route Id values on Add Selected to Route form:
      | trackingId                                 | routeId |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |         |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |         |

  Scenario: Operator Force Success Order on All Orders Page - RTS with COD - Collect COD (uid:80acf3bd-c1c7-4a02-a21b-2008a5f91b84)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | true      |
    Then Operator verifies error messages in dialog on All Orders page:
      | 1.{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} \| Order id = {KEY_LIST_OF_CREATED_ORDER_ID[1]}not allowed to collect cod! |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  Scenario: Operator Force Success Order on All Orders Page - RTS with COD - Do not Collect COD (uid:c61d23ee-53ef-4c59-8bba-b4f16b46a96a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected |
      | {KEY_CREATED_ORDER_TRACKING_ID} | false     |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |

  Scenario: Operator Force Success Order on All Orders Page - End State = Returned to Sender (uid:1ea0141f-e3ef-495c-b9cb-b014cfc7ff73)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success single order on All Orders page
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Force Success Order on All Orders Page - Routed Order Delivery with COD - Collect COD (<uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new COD for created order
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <collected> |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY           |
      | expectedCodAmount | <collected_amount> |
      | driverId          | {ninja-driver-id}  |
    Examples:
      | note               | cod_amount | collected_amount | collected | uid                                      |
      | Collect COD        | 23.57      | 23.57            | true      | uid:ae5c6bab-1d1b-48bf-a32e-779983df9087 |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Force Success Order on All Orders Page - Routed Order Delivery with COD - Do not Collect COD (<uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new COD for created order
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <collected> |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY           |
      | expectedCodAmount | <collected_amount> |
      | driverId          | {ninja-driver-id}  |
    Examples:
      | note               | cod_amount | collected_amount | collected | uid                                      |
      | Do not Collect COD | 23.57      | 0                | false     | uid:a5fbe7f1-650d-48d8-a2cc-29e963ca09d7 |

  Scenario Outline: Operator Force Success Order on All Orders Page - Unrouted Order with COD - Collect COD (<uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <collected> |
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Complete Order     |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY           |
      | expectedCodAmount | <collected_amount> |
    Examples:
      | note               | cod_amount | collected_amount | collected | uid                                      |
      | Collect COD        | 23.57      | 23.57            | true      | uid:d477b7d1-9a47-445b-84ca-34b7c8da10c4 |

  Scenario Outline: Operator Force Success Order on All Orders Page - Unrouted Order with COD - Do not Collect COD (<uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cod_amount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                      | collected   |
      | {KEY_CREATED_ORDER_TRACKING_ID} | <collected> |
    Then Operator verifies that info toast displayed:
      | top    | 1 order(s) updated |
      | bottom | Complete Order     |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    And DB Operator verify the collected sum stored in cod_collections using data below:
      | transactionMode   | DELIVERY           |
      | expectedCodAmount | <collected_amount> |

    Examples:
      | note               | cod_amount | collected_amount | collected | uid                                      |
      | Do not Collect COD | 23.57      | 0                | false     | uid:850b6b66-82aa-45d8-bb7e-f3b602e27f8a |

  Scenario: Operator Force Success Partial Orders on All Orders Page - RTS with COD - Collect COD (uid:8ea6768c-87d4-4845-a769-e99985363cdf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 4                                                                                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS orders:
      | orderId                           | rtsRequest                                                                                                 |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> All Orders
    And Operator Force Success orders with COD collection on All Orders page:
      | trackingId                                 | collected |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | true      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | false     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | true      |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | false     |
    Then Operator verifies error messages in dialog on All Orders page:
      | 1.{KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} \| Order id = {KEY_LIST_OF_CREATED_ORDER_ID[3]}not allowed to collect cod! |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[3]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[4]}"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify order event on Edit order page using data below:
      | name | PRICING CHANGE |
    And Operator verify order event on Edit order page using data below:
      | name | FORCED SUCCESS |

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on All Orders Page (uid:d4c62eac-0614-498b-8d30-9b204a7280f6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Order -> All Orders
    And Operator selects filters on All Orders page:
      | status            | Transit                                                          |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator selects "Save Current as Preset" preset action on All Orders page
    Then Operator verifies Save Preset dialog on All Orders page contains filters:
      | Status: Transit                                                                                   |
      | Creation Time: {gradle-next-0-day-yyyy-MM-dd} 04:00:00 to {gradle-next-1-day-yyyy-MM-dd} 04:00:00 |
      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                                 |
      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name}                  |
    And Operator verifies Preset Name field in Save Preset dialog on All Orders page is required
    And Operator verifies Cancel button in Save Preset dialog on All Orders page is enabled
    And Operator verifies Save button in Save Preset dialog on All Orders page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on All Orders page
    Then Operator verifies Preset Name field in Save Preset dialog on All Orders page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on All Orders page is enabled
    When Operator clicks Save button in Save Preset dialog on All Orders page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset created                    |
      | bottom             | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                       |
    And Operator verifies selected Filter Preset name is "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" on All Orders page
    And DB Operator verifies filter preset record:
      | id        | {KEY_ALL_ORDERS_FILTERS_PRESET_ID}   |
      | namespace | orders                               |
      | name      | {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit                                                          |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on All Orders Page (uid:c75cbb19-213b-4f6c-b7d0-42eec03cd916)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit                                                          |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on All Orders Page (uid:3dd7afce-4f6a-4620-879e-205a80dd2fff)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "Delete Preset" preset action on All Orders page
    Then Operator verifies Cancel button in Delete Preset dialog on All Orders page is enabled
    And Operator verifies Delete button in Delete Preset dialog on All Orders page is disabled
    When Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on All Orders page
    Then Operator verifies "Preset \"{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on All Orders page
    When Operator clicks Delete button in Delete Preset dialog on All Orders page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted                |
      | bottom | ID: {KEY_ALL_ORDERS_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_ALL_ORDERS_FILTERS_PRESET_ID}" filter preset is deleted

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on All Orders Page - via Save Current As Preset Button (uid:5f5aa695-09a3-4e14-8271-13bdff312ab1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    And Operator updates filters on All Orders page:
      | status         | Transit, Cancelled |
      | granularStatus | Cancelled          |
    And Operator selects "Save Current as Preset" preset action on All Orders page
    Then Operator verifies Save Preset dialog on All Orders page contains filters:
      | Status: Cancelled, Transit                                                       |
      | Granular Status: Cancelled                                                       |
      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                |
      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    When Operator enters "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on All Orders page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on All Orders page
    When Operator clicks Update button in Save Preset dialog on All Orders page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                    |
      | bottom             | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                       |
    When Operator refresh page
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit, Cancelled                                               |
      | granularStatus    | Cancelled                                                        |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on All Orders Page - via Update Preset Button (uid:4b08b54f-c866-4434-811f-d559d5e0b99e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    And Operator updates filters on All Orders page:
      | status         | Transit, Cancelled |
      | granularStatus | Cancelled          |
    And Operator selects "Update Preset" preset action on All Orders page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                    |
      | bottom             | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                       |
    When Operator refresh page
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit, Cancelled                                               |
      | granularStatus    | Cancelled                                                        |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op