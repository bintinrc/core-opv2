@OperatorV2Deprecated @OperatorV2Part1Deprecated
Feature: Outbound Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator's searching the outbound data on Outbound Monitoring page (uid:19cba029-d587-4911-9269-b9b4beb4b529)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the route ID is exist on Outbound Monitoring Page

  @DeleteOrArchiveRoute
  Scenario: Operator verifies the In Progress Outbound Status on Outbound Monitoring Page (uid:7974395f-d4c7-4a18-bec7-a203136377df)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the In Progress Outbound Status on Outbound Monitoring Page

  @DeleteOrArchiveRoute
  Scenario: Operator verifies the Complete Outbound Status on Outbound Monitoring Page (uid:85004aba-947b-43eb-9b31-ab69015dae02)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator Outbound Scan parcel using data below:
      | outboundRequest | { "hubId":{hub-id} } |
    Given API Operator start the route
    Given API Driver deliver the created parcel successfully
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the Complete Outbound Status on Outbound Monitoring Page

  @DeleteOrArchiveRoute
  Scenario: Operator clicks on Flag Icon to mark route ID on Outbound Monitoring Page (uid:ae918b82-457e-47fe-a269-7c7cb6733b54)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    When Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the Outbound status on the chosen route ID is changed

  @DeleteOrArchiveRoute
  Scenario: Operator adding comment on the Outbound Monitoring Page (uid:ee8738f0-95b2-4419-8865-0e2f3b5be7bd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    When Operator search on Route ID Header Table on Outbound Monitoring Page
    When Operator click on comment icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the comment table on the chosen route ID is changed

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator should be able to Pull out order from route on Outbound Monitoring page (uid:a0b72c03-6596-454c-a697-00a02ed7984a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound/Route Load Monitoring
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | fromDate | {{previous-1-day-yyyy-MM-dd}} |
      | toDate   | {{current-date-yyyy-MM-dd}}   |
      | zoneName | {zone-name}                   |
      | hubName  | {hub-name}                    |
    When Operator pull out order from route on Outbound Monitoring page
    Then API Operator verify order is pulled out from route

#TO DO : after the page is migrated to OpV2
#  @DeleteOrArchiveRoute
#  Scenario: Operator pull out order on Outbound Monitoring Page
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    Given Operator go to menu New Features -> Outbound Monitoring
#    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
#    When Operator search on Route ID Header Table on Outbound Monitoring Page
#    When Operator click on edit icon on chosen route ID on Outbound Monitoring Page
#    When Operator pull out a tracking ID of the route ID on Outbound Monitoring Page
#    Given Operator go to menu New Features -> Outbound Monitoring
#    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
#    When Operator search on Route ID Header Table on Outbound Monitoring Page
#    Then Operator verifies the Total Parcel in Route is changed on Outbound Monitoring Page

#  @DeleteOrArchiveRoute
#  Scenario: Operator fail pull out order on Outbound Monitoring Page due to van inbounded order
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{hub-id} } |
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    Given API Driver collect all his routes
#    Given API Driver get pickup/delivery waypoint of the created order
#    Given API Operator Van Inbound parcel
#    Given API Operator start the route
#    Given Operator go to menu New Features -> Outbound Monitoring
#    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
#    When Operator search on Route ID Header Table on Outbound Monitoring Page
#    When Operator click on edit icon on chosen route ID on Outbound Monitoring Page
#    When Operator pull out a tracking ID of the route ID on Outbound Monitoring Page
#    Then Operator verifies the pull out process is failed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
