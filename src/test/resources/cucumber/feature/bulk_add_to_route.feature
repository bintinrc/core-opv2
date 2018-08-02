@OperatorV2 @OperatorV2Part2 @AddParcelToRoute @Saas
Feature: Add Parcel To Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteViaDb
  Scenario: Add Parcel To Route (uid:f0213ffe-ff22-43cd-89e3-9f3abbe581e6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transaction to Route Group
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator set tags of the new created route to [{route-tag-id}]
    Given Operator go to menu Routing -> 4. Route Engine - Bulk Add to Route
    When Operator choose route group, select tag "{route-tag-name}" and submit
    Then Operator verify parcel added to route
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
