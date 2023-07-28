@Sort @Inbounding @GlobalInbound @GlobalInboundPart7 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Order Tagging with Global Inbound - Total tags is more than 4 (uid:aecc250f-25a7-49ec-8d19-8634ff2a1d79)
    When Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | 5570                               |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                             |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}    |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3,SORTAUTO02 |
    And Operator verify failed tagging error toast is shown
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify the tags shown on Edit Order V2 page
      | PRIOR |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 48                                 |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |


  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (0 Values) (uid:d2232263-f912-4561-8154-d56327e54ca0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "length":"40", "width":"41", "height":"12", "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                          |
      | trackingId        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideDimHeight | 0                                     |
      | overrideDimWidth  | 0                                     |
      | overrideDimLength | 0                                     |
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

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (NULL Values) (uid:83644b40-cd17-4b3a-b6ba-927a8170a4f3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "length":"40", "width":"41", "height":"12", "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator go to menu Inbounding -> Global Inbound
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

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (with volumetric weight)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                          |
      | trackingId        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideDimHeight | {dimension-height}                    |
      | overrideDimWidth  | {dimension-width}                     |
      | overrideDimLength | {dimension-length}                    |
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
    And Operator verifies order weight is overridden based on the volumetric weight
      | orderHeight | {KEY_LIST_OF_CREATED_ORDERS[1].dimensions.height} |
      | orderWidth  | {KEY_LIST_OF_CREATED_ORDERS[1].dimensions.width}  |
      | orderLength | {KEY_LIST_OF_CREATED_ORDERS[1].dimensions.length} |
      | orderWeight | {KEY_LIST_OF_CREATED_ORDERS[1].dimensions.weight} |

  @CloseNewWindows
  Scenario: Inbound With Device ID (uid:a4df911d-8bf7-43ae-aef0-e791b6e9a664)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | deviceId   | 12345                                 |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op