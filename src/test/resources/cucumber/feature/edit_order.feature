@OperatorV2 @OperatorV2Part2 @EditOrder @Saas
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Operator Edit Order Details on Edit Order page (uid:310145cf-c2c5-4451-9501-637b368d274c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator click Order Settings -> Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page
    When API Operator get order details
    When Operator Edit Order Details on Edit Order page successfully

  @CloseNewWindows
  Scenario: Operator should be able to Edit Instructions of an order on Edit Order page (uid:083eeb16-7b61-4851-8896-70370bc848b6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator click Order Settings -> Edit Instructions on Edit Order page
    When Operator enter Order Instructions on Edit Order page:
      | pickupInstruction   | new pickup instruction   |
      | deliveryInstruction | new delivery instruction |
    When Operator verify Order Instructions are updated on Edit Order Page

  @CloseNewWindows
  Scenario: Operator should be able to Manually Complete Order on Edit Order page (uid:eb872b68-ff7d-4b6d-b5da-98676774bb93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator click Order Settings -> Manually Complete Order on Edit Order page
    When Operator confirm manually complete order on Edit Order page
    Then Operator verify the order completed successfully on Edit Order page

  @CloseNewWindows
  Scenario: Operator should be able to edit the Priority Level (uid:6163a252-e695-4e75-93e2-9c976e03727b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator change Priority Level to "2" on Edit Order page
    And Operator refresh page
    Then Operator verify Delivery Priority Level is "2" on Edit Order page

  @CloseNewWindows
  Scenario: Operator should be able to print the airway bill (uid:f0095133-9d98-47bf-9d34-564917fa5bb4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                 |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info

  @ArchiveRouteViaDb @CloseNewWindows
  Scenario Outline: Operator should be able to add C2C/Return  order to Route for Pickup on Edit Order page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                      |
      | v2OrderRequest    | { "type":"<orderType>", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator add created order to the <routeType> route on Edit Order page
    And Operator refresh page
    Then Operator verify the order is added to the <routeType> route on Edit Order page
    Examples:
      | Note               | hiptest-uid                              | orderType | routeType |
      | C2C - Delivery     | uid:c4f25b56-21c6-4f4a-9521-540a8678fc85 | C2C       | Delivery  |
      | Return - Pickup    | uid:27ec7fb6-c2ac-4764-b483-5c656c72568d | Return    | Pickup    |

#  Scenario: Operator Edit Cash Collection Details on Edit Order page
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given API Shipper create Order V2 Parcel using data below:
#      | generateFromAndTo | RANDOM |
#      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
#    When Operator go to menu Order -> All Orders
#    When Operator find order on All Orders page using this criteria below:
#      | category    | Tracking / Stamp ID           |
#      | searchLogic | contains                      |
#      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
#    When Operator switch to Edit Order's window
#    When Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
#    When Operator Edit Cash Collection Details on Edit Order page
#    When Operator Edit Cash Collection Details on Edit Order page successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
