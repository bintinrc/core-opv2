@Sort @Inbounding @GlobalInbound @GlobalInboundPart4 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario Outline: Inbound parcel at hub on Operator v2 - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<service>", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"XXL", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

    Examples:
      | orderType    | service | hiptest-uid                              | dataset_name |
      | Normal order | Parcel  | uid:1b29cfe9-33b6-498d-80d0-ac89b4868f81 | Normal order |
      | Return order | Return  | uid:2785626f-4012-4a4a-a722-00661a8b4261 | Return order |

  @CloseNewWindows
  Scenario: Global inbounds override the weight and recalculate the price (uid:cc9a0545-0a24-4b7c-ae6d-9ef9aafbdcd6)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}}, "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Pricing - Operator gets the latest priced order history details from the pricing_qa_gl.pricing_orders_history table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator save current order cost "{KEY_PRICING_ORDERS_HISTORY_DETAILS_DB.pricingResult.result.totalWithTax}"
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                          |
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideWeight | 7                                     |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Pricing - Operator gets the latest priced order history details from the pricing_qa_gl.pricing_orders_history table for tracking id "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator verifies order cost is updated
      | previousCost     | {KEY_CURRENT_COST}                                                        |
      | costAfterInbound | {KEY_PRICING_ORDERS_HISTORY_DETAILS_DB.pricingResult.result.totalWithTax} |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | weight         | 7                      |
      | granularStatus | Arrived at Sorting Hub |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator should not be able to Global Inbound routed pending delivery (uid:42638dfc-d876-44a5-b5c0-bf9ba42ba342)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id-3}                            |
      | globalInboundRequest | { "hubId":{hub-id-3} }                |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator refresh page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | ROUTED  |
      | color    | #fa002c |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Inbound On Vehicle for Delivery Order (uid:4d0c8a28-ca6a-4bf0-9505-ce656f1a6179)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API Sort - Operator global inbound
      | hubName              | {hub-name-3}                          |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | globalInboundRequest | { "hubId":{hub-id-3} }                |
    When API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | ROUTED  |
      | color    | #fa002c |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  Scenario: Global inbounds should show error when inbounding with invalid character
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3} |
      | trackingId | /            |
    Then Operator verifies error toast with "Exception" message is shown

  Scenario: Global inbounds should show error when inbounding with more than 50 characters
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                                        |
      | trackingId | 123456789111315171921232527293133353739414345474951 |
    Then Operator verifies error toast with "Exception" message is shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op