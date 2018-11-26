@OperatorV2 @OperatorV2Part2 @ParcelSweeper
Feature: Parcel Sweeper

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator sweep routed Normal Order with valid Tracking ID and using same Hub as the order on Parcel Sweeper page (uid:)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu Routing -> Parcel Sweeper
    When Operator sweep parcel using data below:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | CREATED             |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    Then Operator verify Zone on Parcel Sweeper page using data below:
#      | zoneName | FROM ROUTE DRIVER |
      | color | #73deec |

  @DeleteOrArchiveRoute
  Scenario: Operator sweep routed Normal Order with valid Tracking ID, using same Hub as the order and using Prefix on Parcel Sweeper page (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    Given Operator go to menu Routing -> Parcel Sweeper
    When Operator sweep created parcel using prefix and hub "{hub-name}"
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | CREATED             |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    Then Operator verify Zone on Parcel Sweeper page using data below:
#      | zoneName | {zone-name} |
      | color | #73deec |

  Scenario: Operator sweep un-routed Normal Order with valid Tracking ID and using same Hub as the order on Parcel Sweeper page (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Routing -> Parcel Sweeper
    When Operator sweep parcel using data below:
      | hubName    | {hub-name} |
      | trackingId | CREATED    |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    Then Operator verify Zone on Parcel Sweeper page using data below:
#      | zoneName | {zone-name} |
      | color | #73deec |

  @DeleteOrArchiveRoute
  Scenario: Operator sweep routed Normal Order with valid Tracking ID and using different Hub from the order on Parcel Sweeper page (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    Given Operator go to menu Routing -> Parcel Sweeper
    When Operator sweep parcel using data below:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | CREATED             |
      | driverName | {ninja-driver-name} |
      | color      | #73deec             |
    Then Operator verify Zone on Parcel Sweeper page using data below:
#      | zoneName | {zone-name} |
      | color | #73deec |
    Then Operator verify Destination Hub on Parcel Sweeper page using data below:
      | hubName | {hub-name} |
      | color   | #73deec    |

  Scenario: Operator sweep un-routed Normal Order with valid Tracking ID and using different Hub from the order on Parcel Sweeper page (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Routing -> Parcel Sweeper
    When Operator sweep parcel using data below:
      | hubName    | {hub-name-2} |
      | trackingId | CREATED      |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT ROUTED |
      | driverName | NIL        |
      | color      | #73deec    |
    Then Operator verify Zone on Parcel Sweeper page using data below:
#      | zoneName | {zone-name} |
      | color | #73deec |
    Then Operator verify Destination Hub on Parcel Sweeper page using data below:
      | hubName | GLOBAL INBOUND |
      | color   | #73deec        |

  Scenario: Operator sweep invalid Tracking ID (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Routing -> Parcel Sweeper
    When Operator sweep parcel using data below:
      | hubName    | {hub-name}        |
      | trackingId | INVALIDTRACKINGID |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | orderId    | NOT FOUND |
      | driverName | NIL       |
      | color      | #f45050   |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName | NIL     |
      | color    | #f45050 |
    Then Operator verify Destination Hub on Parcel Sweeper page using data below:
      | hubName | NOT FOUND |
      | color   | #f45050   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op