@Sort @Inbounding @GlobalInbound @GlobalInboundMy @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Inbound Parcel With Weight, Size, Dimensions Changes - AV status unverified (uid:af00df65-c10f-4c7d-bdff-f7ca6abf6a38)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name}                            |
      | parcelType        | {parcel-type-bulky}                   |
      | trackingId        | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideSize      | L                                     |
      | overrideWeight    | 7.2                                   |
      | overrideDimHeight | 12                                    |
      | overrideDimWidth  | 60                                    |
      | overrideDimLength | 50                                    |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | NO AV   |
      | color    | #f7f7f7 |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                                                                                     |
      | eventType | HUB_INBOUND_SCAN                                                                                                                                                                                                                                       |
      | eventData | {"weight": {"old_value": 4,"new_value": 7.2},"length": {"new_value": 50},"width": {"new_value": 60},"height": {"new_value": 12},"parcel_size_id": {"old_value": 0,"new_value": 2},"raw_height": 12,"raw_length": 50,"raw_width": 60,"raw_weight": 7.2} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
      | weight         | 7.2                    |
      | size           | LARGE                  |
      | length         | 50                     |
      | width          | 60                     |
      | height         | 12                     |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name}       |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                      |
      | status             | PENDING                                       |

  @CloseNewWindows
  Scenario: Inbound Parcel With Prior Tag, Priority Level, RTS, and Order Tags - AV status unverified (uid:8242ec27-33a5-46ac-a039-da41ce1c0250)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | 2                                  |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name}                            |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | NO AV   |
      | color    | #f7f7f7 |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name}       |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                      |
      | status             | PENDING                                       |

  @CloseNewWindows
  Scenario: Inbound Parcel With Prior Tag, Priority Level, RTS, and Order Tags - AV status verified (uid:f98adaba-cae8-46ac-84b2-95ee6ca3815b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"65, Persiaran Endah","address2":"","postcode":50460,"country":"MY","latitude":3.1385036,"longitude":101.6169485}}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | 2                                  |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk multiple address CSV using data below:
      | method                     | waypoint                                                   | toAddress1                                 | latitude  | longitude   |
      | FROM_CREATED_ORDER_DETAILS | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} | 3.2201775 | 101.6698116 |
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator verify that "VERIFY_ADDRESS" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name}                            |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | color          | #f06c00                                        |
      | rtsTag         | RTS                                            |
      | priorTag       | Prior.                                         |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator unmask Edit Order V2 page
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name}       |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                      |
      | status             | PENDING                                       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op