@OperatorV2 @OperatorV2Part1 @OutboundAndRouteLoadMonitoring @Saas
Feature: Outbound Monitoring
  Note: Please complete this scenarios below. Some of the steps below already implemented,
  so no need to create your own implementation. Implement the Java code only for the line that says
  "Implement this step:". Will give you a briefing later so you can have a sense about how our automation project works.

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator verifies the created route is exist and will gone from table when filter Show only "Partially loaded route" is enable
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring

    # Implement this step: Then Operator verifies the route is exist
    # Note: To get the created route, use this code below on this step Java implementation:
    # Long routeId = get(KEY_CREATED_ROUTE_ID);

    # Implement this step: When Operator enable filter Show only "Partially loaded route"

    # Implement this step: Then Operator verifies the created route is gone from table

  @CWF @RT
  Scenario: Operator verifies the created route is exist and will still be displayed on table when filter Show only "Partially loaded route" is enable
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring

    # Implement this step: Then Operator verifies the route is exist

    # Implement this step: When Operator enable filter Show only "Partially loaded route"

    # Implement this step: Then Operator verifies the created route is still displayed on table

  Scenario: Operator verifies route contains 2 Parcels Assigned, 0 Parcels Loaded, 0 Parcels Passed Back and 2 Missing Parcels
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring

    # Implement this step: When Operator finds the created route

    # Implement this step: Then Operator verifies the route is exist and the info in the row is correct.
    # Note, please verify this:
    # - Driver Name is correct: You can get the expected driver name from this properties {ninja-driver-name}
    # - Parcels Assigned = 2
    # - Parcels Loaded = 0
    # - Parcels Passed Back = 0
    # - Parcels Missing Parcels = 2

    # Implement this step: When Operator clicks the number on Parcels Assigned column

    # Implement this step: Then Operator verifies the Transaction Log contains all created Tracking ID
    # Note: To get the list of created Tracking ID, use this code below on this step Java implementation:
    # List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    # Implement this step: When Operator clicks the number on Missing Parcels column

    # Implement this step: Then Operator verifies the Transaction Log contains all created Tracking ID

  Scenario: Operator verifies route contains 2 Parcels Assigned, 2 Parcels Loaded, 2 Parcels Passed Back and 0 Missing Parcels
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring

    # Implement this step: When Operator finds the created route

    # Implement this step: Then Operator verifies the route is exist and the info in the row is correct.
    # Note, please verify this:
    # - Driver Name is correct: You can get the expected driver name from this properties {ninja-driver-name}
    # - Parcels Assigned = 2
    # - Parcels Loaded = 2
    # - Parcels Passed Back = 2
    # - Parcels Missing Parcels = 0

    # Implement this step: When Operator clicks the number on Parcels Assigned column

    # Implement this step: Then Operator verifies the Transaction Log contains all created Tracking ID

    # Implement this step: When Operator clicks the number on Parcels Loaded column

    # Implement this step: Then Operator verifies the Transaction Log contains all created Tracking ID

    # Implement this step: When Operator clicks the number on Parcels Passed Back column

    # Implement this step: Then Operator verifies the Transaction Log contains all created Tracking ID