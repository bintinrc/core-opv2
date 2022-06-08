@OperatorV2 @Core @Order @EditOrder
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Print the Airway Bill On Edit Order Page (uid:e017c4ea-2015-420d-a86e-a884ffbf89e0)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info

  @DeleteOrArchiveRoute
  Scenario: Operator View POD from Edit Order Page (uid:87f02736-7ccf-4d62-a3e3-fd81636a36ab)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver all created parcels successfully
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click View/Print -> View all PODs on Edit Order page
    Then Operator verify delivery POD details is correct on Edit Order page using date below:
      | driver              | {ninja-driver-name} |
      | verification method | NO_VERIFICATION     |

  @DeleteOrArchiveRoute
  Scenario: Operator Reverify Order Address in Edit Order Page (uid:4021b29d-4ddf-4cd8-9141-b56f1e0fa6c0)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Reverify Delivery Address on Edit Order page
    And Operator verifies that info toast displayed:
      | top | Reverified Successfully |
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order:
      | archived | score |
      | 1        | 1.0   |
      | 0        | 0.5   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op