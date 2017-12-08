@OperatorV2 @AddParcelToRoute
Feature: Add Parcel To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute
  Scenario: Add Parcel To Route (uid:f0213ffe-ff22-43cd-89e3-9f3abbe581e6)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transaction to Route Group
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":16, "hubId":1, "vehicleId":880, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}" } |
    #Note: Tag ZZZ = 250
    Given Operator set tags of the new created route to [250]
    Given Operator go to menu Routing -> 4. Route Engine - Bulk Add to Route
    When Operator V2 choose route group, select tag "ZZZ" and submit
    Then verify parcel added to route
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
