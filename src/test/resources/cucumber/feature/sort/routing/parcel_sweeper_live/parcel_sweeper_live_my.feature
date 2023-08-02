@Sort @Routing @ParcelSweeperLive @ParcelSweeperLiveMy
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Parcel Sweeper Parcel With Prior Tag, Priority Level, RTS, and Order Tags - AV status unverified (uid:c4220762-4144-44a6-947b-69ca13a761fb)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
#    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | priorityLevel | 100                                |
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | 2                                  |
#    And API Shipper tags multiple parcels as per the below tag
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | routeId         | No AV                |
      | backgroundColor | {success-bg-inbound} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows
  Scenario: Parcel Sweeper Parcel With Prior Tag, Priority Level, RTS, and Order Tags - AV status verified (uid:17a2e3f2-3fa5-4566-95cf-c8b47c81a97b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"65, Persiaran Endah","address2":"","postcode":50460,"country":"MY","latitude":3.1385036,"longitude":101.6169485}}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | priorityLevel | 100                                |
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
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator upload bulk address CSV using data below:
      | order      | {KEY_LIST_OF_CREATED_ORDERS[1]}                            |
      | method     | FROM_CREATED_ORDER_DETAILS                                 |
      | waypoint   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | latitude   | 4.0151025                                                  |
      | longitude  | 100.9532552                                                |
    And Operator verifies waypoints are assigned to "RTS" rack sector upon bulk address verification
    Then Operator clicks Update successful matched on Bulk Address Verification page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor | {success-bg-inbound} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName  | {rts-zone-name}  |
      | textColor | {blue-hex-color} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {dark-gray-hex-color}                          |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type   | DELIVERY |
      | status | PENDING  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op