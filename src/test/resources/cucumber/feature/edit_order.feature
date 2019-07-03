@OperatorV2 @OperatorV2Part2 @EditOrder @Saas
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Operator Edit Order Details on Edit Order page (uid:310145cf-c2c5-4451-9501-637b368d274c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator click Order Settings -> Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page successfully

  @CloseNewWindows
  Scenario: Operator should be able to Edit Instructions of an order on Edit Order page (uid:083eeb16-7b61-4851-8896-70370bc848b6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario Outline: Operator should be able to add C2C/Return  order to Route for Pickup on Edit Order page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | Note              | hiptest-uid                              | orderType | routeType |
      | Return - Delivery | uid:c4f25b56-21c6-4f4a-9521-540a8678fc85 | Return    | Delivery  |
      | Return - Pickup   | uid:27ec7fb6-c2ac-4764-b483-5c656c72568d | Return    | Pickup    |

#  Scenario: Operator Edit Cash Collection Details on Edit Order page
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    When Operator go to menu Order -> All Orders
#    When Operator find order on All Orders page using this criteria below:
#      | category    | Tracking / Stamp ID           |
#      | searchLogic | contains                      |
#      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
#    When Operator switch to Edit Order's window
#    When Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
#    When Operator Edit Cash Collection Details on Edit Order page
#    When Operator Edit Cash Collection Details on Edit Order page successfully

  @CloseNewWindows
  Scenario: Operator should be able to update Stamp ID from Edit Order page ()
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator change Stamp ID of the created order to "GENERATED" on Edit order page

  @CloseNewWindows
  Scenario: Operator should be able to update order status from Pending/Pending to Transit/Arrived at Sorting Hub on Edit Order page ()
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator update status of the created order on Edit order page using data below:
      | status                        | Transit                |
      | granularStatus                | Arrived at Sorting Hub |
      | lastPickupTransactionStatus   | Success                |
      | lastDeliveryTransactionStatus | Pending                |
    When Operator verify the created order info is correct on Edit Order page

  @CloseNewWindows
  Scenario: Operator should be able to update order status from Pending/Pending to Completed/Completed on Edit Order page ()
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator update status of the created order on Edit order page using data below:
      | status                        | Completed |
      | granularStatus                | Completed |
      | lastPickupTransactionStatus   | Success   |
      | lastDeliveryTransactionStatus | Success   |
    When Operator verify the created order info is correct on Edit Order page
    And Operator verify color of order header on Edit Order page is "GREEN"

  @CloseNewWindows
  Scenario: Operator should be able to update order status from Pending/Pending to Cancelled/Cancelled on Edit Order page ()
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator update status of the created order on Edit order page using data below:
      | status                        | Cancelled |
      | granularStatus                | Cancelled |
      | lastPickupTransactionStatus   | Cancelled |
      | lastDeliveryTransactionStatus | Cancelled |
    When Operator verify the created order info is correct on Edit Order page
    And Operator verify color of order header on Edit Order page is "RED"

  @CloseNewWindows
  Scenario: Operator should be able to update order status from Transit/Arrived at Sorting Hub to Pending/Pending on Edit Order page ()
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    When Operator go to menu Order -> All Orders
    When Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    When Operator update status of the created order on Edit order page using data below:
      | status                        | Pending        |
      | granularStatus                | Pending Pickup |
      | lastPickupTransactionStatus   | Pending        |
      | lastDeliveryTransactionStatus | Pending        |
    When Operator verify the created order info is correct on Edit Order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Pending Pickup
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status  | CANCELLED |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Van En-route to Pickup
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Van En-route to Pickup" on Edit Order page
    And Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status  | CANCELLED |
      | routeId |           |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Pickup Fail
    When Operator go to menu Shipper Support -> Blocked Dates
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
    And Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Pickup Fail" on Edit Order page
    And Operator verify order granular status is "Pickup Fail" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status  | FAIL                 |
      | routeId | KEY_CREATED_ROUTE_ID |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Staging
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    When API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver get estimated price of hyperlocal order
    Then API Driver success reservation while creating hyperlocal order
    And API Operator verify hyperlocal order created
    And Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Staging" on Edit Order page
    And Operator verify order granular status is "Staging" on Edit Order page
    And Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    When API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op