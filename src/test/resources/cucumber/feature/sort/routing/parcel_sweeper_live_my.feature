@Sort @Routing @ParcelSweeperLive @ParcelSweeperLiveMy
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Parcel Sweeper Parcel With Prior Tag, Priority Level, RTS, and Order Tags - AV status unverified (uid:c4220762-4144-44a6-947b-69ca13a761fb)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | priorityLevel | 100                               |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 2 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId | NOT ROUTED |
      | color   | #cccccc    |
    When API Operator get all zones preferences
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NO AV   |
      | color    | #cccccc |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | -       |
      | color   | #cccccc |
    When Operator switch to edit order page using direct URL
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @CloseNewWindows
  Scenario: Parcel Sweeper Parcel With Prior Tag, Priority Level, RTS, and Order Tags - AV status verified (uid:17a2e3f2-3fa5-4566-95cf-c8b47c81a97b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"65, Persiaran Endah","address2":"","postcode":50460,"country":"MY","latitude":3.1385036,"longitude":101.6169485}}}} |
    And API Operator update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | priorityLevel | 100                               |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 2 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | 4.0151025                  |
      | longitude | 100.9532552                |
    And Operator verifies waypoints are assigned to "RTS" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    When API Operator refresh created order data
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                      |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId | NOT ROUTED |
      | color   | #55a1e8    |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | {rts-zone-name} |
      | color    | #55a1e8         |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName | {KEY_CREATED_ORDER.destinationHub} |
      | color   | #55a1e8                            |
    When Operator switch to edit order page using direct URL
    And Operator verifies event is present for order on Edit order page
      | eventName | PARCEL ROUTING SCAN |
      | hubName   | {hub-name}          |
      | hubId     | {hub-id}            |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op