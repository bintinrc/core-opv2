@OperatorV2 @Core @Inbounding @RouteInbound @happy-path
Feature: Inbound COD & COP

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario Outline: Inbound Cash for COD (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":<cashOnDelivery>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu Inbounding -> Route Inbound
    When Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | {hub-name}                    |
      | fetchBy      | FETCH_BY_TRACKING_ID          |
      | fetchByValue | KEY_CREATED_ORDER_TRACKING_ID |
    Then Operator verify the Route Summary Details is correct using data below:
      | routeId     | {KEY_CREATED_ROUTE_ID} |
      | driverName  | {ninja-driver-name}    |
      | hubName     | {hub-name}             |
      | routeDate   | GET_FROM_CREATED_ROUTE |
      | wpPending   | 0                      |
      | wpPartial   | 0                      |
      | wpFailed    | 0                      |
      | wpCompleted | 1                      |
      | wpTotal     | 1                      |
    When Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    Then Operator verify 'Money to collect' value is "<cashOnDelivery>" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    Then Operator verify 'Expected Total' value is "<cashOnDelivery>" on Money Collection dialog
    And Operator verify 'Outstanding amount' value is "<cashOnDelivery>" on Money Collection dialog
    When Operator submit following values on Money Collection dialog:
      | cashCollected   | <cashCollected>   |
      | creditCollected | <creditCollected> |
      | receiptId       | <receiptId>       |
    Then Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator verify 'Outstanding amount' value is "Fully Collected" on Money Collection dialog
    Examples:
      | Title                            | hiptest-uid                              | cashCollected | creditCollected | receiptId | cashOnDelivery |
      | Inbound Cash Only                | uid:24674576-d71b-44a9-bb42-8f2b42fb97d6 | 23.57         |                 |           | 23.57          |
      | Inbound Credit Only              | uid:a61424da-030c-4e3c-8371-c0b0d42eaeb3 |               | 23.57           | 123       | 23.57          |
      | Inbound Split Into Cash & Credit | uid:0fd362ee-b81d-4a2e-8805-c4724a4d78d0 | 10.0          | 13.57           | 123       | 23.57          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op