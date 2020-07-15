@OperatorV2 @Routing @RouteMonitoringV2 @Core
Feature: Route Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Single Transaction
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator filter Route Monitoring V2 using data below and then load selection:
      | hubs  | {hub-name}  |
      | zones | {zone-name} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 1                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Multiple Transactions
    When API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator filter Route Monitoring V2 using data below and then load selection:
      | hubs  | {hub-name}  |
      | zones | {zone-name} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 3                      |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Route Monitoring Data And Checks Total Parcel for Each Route - Reservation
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator add reservation pick-up to the route
    When Operator go to menu Routing -> Route Monitoring V2
    Then Route Monitoring V2 page is loaded
    When Operator filter Route Monitoring V2 using data below and then load selection:
      | hubs  | {hub-name}  |
      | zones | {zone-name} |
    Then Operator verify parameters of a route on Route Monitoring V2 page using data below:
      | routeId      | {KEY_CREATED_ROUTE_ID} |
      | totalParcels | 0                      |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
