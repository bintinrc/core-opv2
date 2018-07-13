@OperatorV2 @OperatorV2Part1 @OutboundMonitoring @Saas
Feature: Outbound Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Operator's searching the outbound data on Outbound Monitoring page (uid:19cba029-d587-4911-9269-b9b4beb4b529)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
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
    Given Operator go to menu New Features -> Outbound Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the route ID is exist on Outbound Monitoring Page

  @ArchiveRouteViaDb
  Scenario: Operator verifies the In Progress Outbound Status on Outbound Monitoring Page (uid:7974395f-d4c7-4a18-bec7-a203136377df)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
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
    Given Operator go to menu New Features -> Outbound Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the In Progress Outbound Status on Outbound Monitoring Page

  @ArchiveRouteViaDb
  Scenario: Operator verifies the Complete Outbound Status on Outbound Monitoring Page (uid:85004aba-947b-43eb-9b31-ab69015dae02)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator Outbound Scan parcel using data below:
      | outboundRequest | { "hubId":{hub-id} } |
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu New Features -> Outbound Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    Then Operator verify the Complete Outbound Status on Outbound Monitoring Page

  @ArchiveRouteViaDb
  Scenario: Operator clicks on Flag Icon to mark route ID on Outbound Monitoring Page (uid:ae918b82-457e-47fe-a269-7c7cb6733b54)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
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
    Given Operator go to menu New Features -> Outbound Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    And Operator click on flag icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the Outbound status on the chosen route ID is changed

  @ArchiveRouteViaDb
  Scenario: Operator adding comment on the Outbound Monitoring Page (uid:ee8738f0-95b2-4419-8865-0e2f3b5be7bd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
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
    Given Operator go to menu New Features -> Outbound Monitoring
    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
    And Operator search on Route ID Header Table on Outbound Monitoring Page
    And Operator click on comment icon on chosen route ID on Outbound Monitoring Page
    Then Operator verifies the comment table on the chosen route ID is changed

#TO DO : after the page is migrated to OpV2
#  @ArchiveRouteViaDb
#  Scenario: Operator pull out order on Outbound Monitoring Page
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given API Shipper create Order V2 Parcel using data below:
#      | generateFromAndTo | RANDOM |
#      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    Given Operator go to menu New Features -> Outbound Monitoring
#    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
#    And Operator search on Route ID Header Table on Outbound Monitoring Page
#    And Operator click on edit icon on chosen route ID on Outbound Monitoring Page
#    And Operator pull out a tracking ID of the route ID on Outbound Monitoring Page
#    Given Operator go to menu New Features -> Outbound Monitoring
#    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
#    And Operator search on Route ID Header Table on Outbound Monitoring Page
#    Then Operator verifies the Total Parcel in Route is changed on Outbound Monitoring Page

#  @ArchiveRouteViaDb
#  Scenario: Operator fail pull out order on Outbound Monitoring Page due to van inbounded order
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given API Shipper create Order V2 Parcel using data below:
#      | generateFromAndTo | RANDOM |
#      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
#    And API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
#    And API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    And API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    And API Driver collect all his routes
#    And API Driver get pickup/delivery waypoint of the created order
#    And API Operator Van Inbound parcel
#    And API Operator start the route
#    Given Operator go to menu New Features -> Outbound Monitoring
#    When Operator click on 'Load Selection' Button on Outbound Monitoring Page
#    And Operator search on Route ID Header Table on Outbound Monitoring Page
#    And Operator click on edit icon on chosen route ID on Outbound Monitoring Page
#    And Operator pull out a tracking ID of the route ID on Outbound Monitoring Page
#    Then Operator verifies the pull out process is failed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
