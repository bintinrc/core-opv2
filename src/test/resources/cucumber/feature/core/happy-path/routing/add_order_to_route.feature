@OperatorV2 @Core @Routing @AddOrderToRoute @happy-path
Feature: Add Order To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Add Order to a Route - Valid Tracking ID, No Prefix (uid:62260562-a35c-4918-bdbf-02f0f0c9b62f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Add Order to Route
    And Operator set "{KEY_CREATED_ROUTE_ID}" route id on Add Order to Route page
    And Operator set "Delivery" transaction type on Add Order to Route page
    And Operator enters "{KEY_CREATED_ORDER_TRACKING_ID}" tracking id on Add Order to Route page
    Then Operator verifies that "Order {KEY_CREATED_ORDER_TRACKING_ID} added to route {KEY_CREATED_ROUTE_ID}" success toast message is displayed
    And Operator verifies the last scanned tracking id is "{KEY_CREATED_ORDER_TRACKING_ID}"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE           |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op