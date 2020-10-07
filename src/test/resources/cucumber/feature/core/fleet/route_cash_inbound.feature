@OperatorV2 @Core @Fleet @RouteCashInbound @Saas
Feature: Route Cash Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Create, Update and Delete COD on Route Cash Inbound Page (uid:67924f18-c541-45d2-b49a-cbea23eaf713)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver deliver the created parcel successfully
    Given Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    When Operator update the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is updated successfully
    When Operator delete the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is deleted successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Fetch COD Inbound with Date Range Filter (uid:9c7561eb-7a6b-4ab2-85eb-a8953a1846a9)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Driver deliver the created parcel successfully
    When Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    Then Operator check filter on Route Cash Inbound page work fine
    When Operator delete the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is deleted successfully

  @DeleteOrArchiveRoute
  Scenario: Operator Download and Verify Cash Inbound CSV File (uid:e45f5794-4c75-4d55-adbb-faacc380e54f)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
    And API Driver deliver the created parcel successfully
    When Operator go to menu Fleet -> Route Cash Inbound
    And Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    When Operator download COD CSV file on Route Cash Inbound page
    Then Operator verify COD CSV file on Route Cash Inbound page is downloaded successfully
    When Operator delete the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op