@OperatorV2 @Order @OperatorV2Part2 @EditOrder @Saas
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
    And DB Operator verify order_events record for the created order:
      | type | 14 |
    And Operator verify order event on Edit order page using data below:
      | name    | UPDATE INSTRUCTION |

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

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - En-route to Sorting Hub
    When Operator go to menu Shipper Support -> Blocked Dates
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
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    Then API Operator cancel created order and get error:
      | statusCode | 500                               |
      | message    | Order is En-route to Sorting Hub! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    Then Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Arrived at Sorting  Hub
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then API Operator cancel created order and get error:
      | statusCode | 500                              |
      | message    | Order is Arrived at Sorting Hub! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

#  @DeleteOrArchiveRoute @CloseNewWindows
#  Scenario: Cancel Order - Arrived at Origin Hub
#    When Operator go to menu Shipper Support -> Blocked Dates
#    And API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
#      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{origin-hub-id} } |
#    Then API Operator cancel created order and get error:
#      | statusCode | 500                              |
#      | message    | Order is Arrived at Origin Hub! |
#    When Operator go to menu Order -> All Orders
#    And Operator find order on All Orders page using this criteria below:
#      | category    | Tracking / Stamp ID           |
#      | searchLogic | contains                      |
#      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
#    And Operator switch to Edit Order's window
#    Then Operator verify order status is "Transit" on Edit Order page
#    And Operator verify order granular status is "Arrived at Origin Hub" on Edit Order page
#    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - On Vehicle for Delivery
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
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
    Then API Operator cancel created order and get error:
      | statusCode | 500                               |
      | message    | Order is On Vehicle for Delivery! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Returned to Sender
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator force succeed created order
    Then API Operator cancel created order and get error:
      | statusCode | 500                          |
      | message    | Order is Returned to Sender! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Returned to Sender" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Arrived at Distribution Point
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
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
    And API Driver deliver the created parcel successfully
    Then API Operator cancel created order and get error:
      | statusCode | 500                          |
      | message    | Order is Arrived at Distribution Point! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Distribution Point" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Completed
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver deliver the created parcel successfully
    Then API Operator cancel created order and get error:
      | statusCode | 500                 |
      | message    | Order is Completed! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Cancelled
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
#    Then API Operator cancel created order and get error:
#      | statusCode | 500                 |
#      | message    | Order is Completed! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Transferred to 3PL
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
    Then API Operator cancel created order and get error:
      | statusCode | 500                          |
      | message    | Order is Transferred to 3PL! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Transferred to 3PL" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Cancel Order - Transferred to 3PL
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Fleet (First Mile) |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    Then API Operator cancel created order and get error:
      | statusCode | 500                          |
      | message    | Order is On Hold! |
    When Operator go to menu Order -> All Orders
    And Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    And Operator switch to Edit Order's window
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator verify menu item "Order Settings" > "Cancel Order" is disabled on Edit order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Edit Pickup Details on Edit Order page (uid:bdf1d848-7fdc-4df8-8794-2e2d6f560692)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Pickup -> Edit Pickup Details on Edit Order page
    And Operator update Pickup Details on Edit Order Page
      | senderName        | test sender name         |
      | senderContact     | +9727894434              |
      | senderEmail       | test@mail.com            |
      | internalNotes     | test internalNotes       |
      | pickupDate        | {{next-1-day-yyyy-MM-dd}}|
      | pickupTimeslot    | 9AM - 12PM               |
      | country           | Singapore                |
      | city              | Singapore                |
      | address1          | 116 Keng Lee Rd          |
      | address2          | 15                       |
      | postalCode        | 308402                   |
    Then Operator verify Pickup "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Pickup "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Pickup "UPDATE SLA" order event description on Edit order page
    And Operator verify Pickup "VERIFY ADDRESS" order event description on Edit order page
    And Operator verifies Pickup Details are updated on Edit Order Page
    And Operator verifies Pickup Transaction is updated on Edit Order Page
    And DB Operator verifies pickup info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 7    |
      | 17   |
      | 11   |
      | 12   |
    And DB Operator verify Pickup '17' order_events record for the created order
    And DB Operator verify Pickup transaction record is updated for the created order
    And DB Operator verify Pickup waypoint record is updated

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Edit Delivery Details on Edit Order page (uid:9157049d-153c-4a69-a80d-bbede3ff98f0)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And Operator update Delivery Details on Edit Order Page
      | recipientName        | test sender name         |
      | recipientContact     | +9727894434              |
      | recipientEmail       | test@mail.com            |
      | internalNotes        | test internalNotes       |
      | deliveryDate         | {{next-1-day-yyyy-MM-dd}}|
      | deliveryTimeslot     | 9AM - 12PM               |
      | country              | Singapore                |
      | city                 | Singapore                |
      | address1             | 116 Keng Lee Rd          |
      | address2             | 15                       |
      | postalCode           | 308402                   |
    Then Operator verify Delivery "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Delivery "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Delivery "UPDATE SLA" order event description on Edit order page
    And Operator verify Delivery "VERIFY ADDRESS" order event description on Edit order page
    And Operator verifies Delivery Details are updated on Edit Order Page
    And Operator verifies Delivery Transaction is updated on Edit Order Page
    And DB Operator verifies delivery info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 7    |
      | 17   |
      | 11   |
      | 12   |
    And DB Operator verify Delivery '17' order_events record for the created order
    And DB Operator verify Delivery transaction record is updated for the created order
    And DB Operator verify Delivery waypoint record is updated

  @CloseNewWindows
  Scenario: Operator Tag Order to DP (uid:63a2e093-e497-4369-b75c-86acbcf5d099)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "12356" DP on Edit Order Page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order Page
    When DB Operator get DP address by ID = "12356"
    Then DB Operator verifies orders record using data below:
      | toAddress1 | GET_FROM_CREATED_ORDER |
      | toAddress2 | GET_FROM_CREATED_ORDER |
      | toPostcode | GET_FROM_CREATED_ORDER |
      | toCity     | GET_FROM_CREATED_ORDER |
      | toCountry  | GET_FROM_CREATED_ORDER |
      | toState    |                        |
      | toDistrict |                        |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | 12356 |
      | address1              | GET_FROM_CREATED_ORDER      |
      | address2              | GET_FROM_CREATED_ORDER      |
      | postcode              | GET_FROM_CREATED_ORDER      |
      | city                  | GET_FROM_CREATED_ORDER      |
      | country               | GET_FROM_CREATED_ORDER      |
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 18    |

  @CloseNewWindows
  Scenario: Operator Untag/Remove order from DP (uid:b8827dd0-a733-4724-a0d2-b9e777d4c1a3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "12356" DP on Edit Order Page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
#  initially city is ""
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | null |
      | address1              | GET_FROM_CREATED_ORDER      |
      | address2              | GET_FROM_CREATED_ORDER      |
      | postcode              | GET_FROM_CREATED_ORDER      |
      | city                  | GET_FROM_CREATED_ORDER      |
      | country               | GET_FROM_CREATED_ORDER      |
    And DB Operator verifies delivery info is updated in order record
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 35    |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator reschedule fail pickup (uid:ae4caac7-69d1-4cb0-adff-b3fb10ed23e9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator fail pickup waypoint from Route Manifest page
    When Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    When Operator reschedule Pickup on Edit Order Page
    | senderName        | test sender name         |
    | senderContact     | +9727894434              |
    | senderEmail       | test@mail.com            |
    | internalNotes     | test internalNotes       |
    | pickupDate        | {{next-1-day-yyyy-MM-dd}}|
    | pickupTimeslot    | 9AM - 12PM               |
    | country           | Singapore                |
    | city              | Singapore                |
    | address1          | 116 Keng Lee Rd          |
    | address2          | 15                       |
    | postalCode        | 308402                   |
  And DB Operator verifies pickup info is updated in order record
  And DB Operator verify Pickup waypoint record for Pending transaction
  And DB Operator verifies orders record using data below:
  | status         | Pending        |
  | granularStatus | Pending Pickup |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator reschedule fail delivery (uid:72abb7c8-affc-4d26-9fba-22512acf7359)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Route Logs
    When Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator open Route Manifest of created route from Route Logs page
    When Operator fail delivery waypoint from Route Manifest page
    When Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    When Operator reschedule Delivery on Edit Order Page
      | recipientName        | test recipient name      |
      | recipientContact     | +9727894434              |
      | recipientEmail       | test@mail.com            |
      | internalNotes        | test internalNotes       |
      | deliveryDate         | {{next-1-day-yyyy-MM-dd}}|
      | deliveryTimeslot     | 9AM - 12PM               |
      | country              | Singapore                |
      | city                 | Singapore                |
      | address1             | 116 Keng Lee Rd          |
      | address2             | 15                       |
      | postalCode           | 308402                   |
    And DB Operator verifies delivery info is updated in order record
    And DB Operator verify Delivery waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows
  Scenario: Operator delete order (uid:9a593a7f-bbfa-43c0-88f9-568d34afc158)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    And Operator verifies All Orders Page is displayed
    Then DB Operator verifies order is deleted

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator pull out parcel from a route (OPV2) - PICKUP (uid:ed1e8f6c-0483-463f-866a-fb1eec3cd2f6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator open page of the created order from All Orders page
    And Operator click Pickup -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verify Pickup transaction on Edit order page using data below:
      | routeId |           |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | routeId | null |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator pull out parcel from a route (OPV2) - DELIVERY (uid:b4262bec-47f3-4e1b-a714-575e388656ef)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator start the route
    And API Operator get order details
    Then Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verify Delivery transaction on Edit order page using data below:
      | routeId |   |
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | routeId | null |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies waypoint for Delivery transaction is deleted from route_waypoint table

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with New Stamp ID (uid:a9c0a02d-1909-4bcc-8a94-3f19217defc0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    Then Operator verify next order info on Edit order page:
      | stampId | KEY_STAMP_ID |
    And DB Core Operator gets Order by Stamp ID
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID |
      | searchLogic | contains            |
      | searchTerm  | KEY_STAMP_ID        |
    When Operator switch to Edit Order's window

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Another Order's Tracking ID (uid:6892e437-71de-425a-8d50-bb8d2022ab70)
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
    And DB Core Operator gets random trackingId
    When Operator unable to change Stamp ID of the created order to "KEY_ANOTHER_ORDER_TRACKING_ID" on Edit order page
    And Operator refresh page
    Then Operator verify next order info on Edit order page:
      | stampId | - |

  @CloseNewWindows
  Scenario: Update Stamp ID - Update Stamp ID with Stamp ID that have been used before (uid:a3e412f4-b821-49c8-83ee-9fc882f17dea)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And DB Core Operator gets order with Stamp ID
    And Operator unable to change Stamp ID of the created order to "KEY_LAST_STAMP_ID" on Edit order page
    And Operator refresh page
    Then Operator verify next order info on Edit order page:
      | stampId | - |

  @CloseNewWindows
  Scenario: Remove Stamp ID (uid:81f446cb-790a-4751-bc57-427a038e3474)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Stamp ID of the created order to "GENERATED" on Edit order page
    And Operator remove Stamp ID of the created order on Edit order page
    And Operator verify next order info on Edit order page:
      | stampId | - |
    When Operator go to menu Order -> All Orders
    Then Operator can't find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_STAMP_ID                  |

  @CloseNewWindows
  Scenario: Edit Cash Collection Details - Edit Cash on Pickup PP (uid:7563a418-d677-4bf8-b03e-e2c99750002f)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change the COP value to "100"
    And Operator refresh page
    Then Operator verify COP value is updated to "100"
    And Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15    |

  @CloseNewWindows
  Scenario: Edit Cash Collection Details - Edit Cash on Delivery DD (uid:d698b8cb-1ba6-4547-9f95-620b7d7ae7b2)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15    |

  @CloseNewWindows
  Scenario: Edit Cash Collection Details - Add Cash on Pickup PP (uid:ccf868b7-5317-478d-b6da-e519c757db62)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Pickup toggle to yes
    And Operator change the COP value to "100"
    And Operator refresh page
    Then Operator verify COP value is updated to "100"
    And DB Operator verify the order_events record exists for the created order with type:
      | 15    |

  @CloseNewWindows
  Scenario: Edit Cash Collection Details - Add Cash on Delivery DD (uid:55f9301a-df97-4f61-9b4b-6454e069765c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to yes
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And DB Operator verify the order_events record exists for the created order with type:
      | 15    |

  @CloseNewWindows
  Scenario: Edit Cash Collection Details - Remove Cash on Pickup PP (uid:5592dc3e-23ae-4b83-9a10-beb52431d116)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Pickup toggle to no
    And Operator refresh page
    And Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15    |

  @CloseNewWindows
  Scenario: Edit Cash Collection Details - Remove Cash on Delivery DD (uid:2fb62b3f-b2fc-499a-a5dd-89069a556c1a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    Then Operator find order on All Orders page using this criteria below:
      | category    | Tracking / Stamp ID           |
      | searchLogic | contains                      |
      | searchTerm  | KEY_CREATED_ORDER_TRACKING_ID |
    When Operator switch to Edit Order's window
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to no
    And Operator refresh page
    And Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15    |

  @CloseNewWindows
  Scenario: Operator Edit Priority Level (uid:2d80a8b7-a7e3-4bf5-9284-5853f85d77b4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    When Operator change Priority Level to "2" on Edit Order page
    Then Operator verify Delivery Priority Level is "2" on Edit Order page
    And DB Operator verify next Delivery transaction values are updated for the created order:
      | priorityLevel | 2 |
    And DB Operator verify next Pickup transaction values are updated for the created order:
      | priorityLevel | 0 |
    And DB Operator verify order_events record for the created order:
      | type | 17 |
    And Operator verify order event on Edit order page using data below:
      | name    | UPDATE SLA |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
