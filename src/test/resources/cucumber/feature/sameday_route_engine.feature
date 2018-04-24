@OperatorV2Disabled @SamedayRouteEngine
Feature: Sameday Route Engine

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add sameday parcel to route (uid:24baa07a-b688-4586-8a90-e5154031b1f1)
    #Notes: Shipper create sameday parcel with OC V2
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transaction to Route Group
    Given Operator go to menu Routing -> 5. Route Engine - Same-Day Route Engine
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Same Day Pickup/Delivery |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
    Then  op create the suggested route
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator V2 clean up 'Route Groups'

  Scenario: Add bulky parcel to route (uid:477e2e7a-76e7-40e7-8355-866783b2faaa)
    Given Operator go to menu Shipper Support -> Blocked Dates
    #Notes: Shipper create C2C Bulky parcel with OC V2
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "parcels":[{ "parcel_size_id":0, "volume":1, "weight":4, "bulky_job":{ "installation_required":true, "flight_of_stairs":1, "sku":"AUTOMATA1" }}], "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transaction to Route Group
    Given Operator go to menu Routing -> 5. Route Engine - Same-Day Route Engine
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
      | fleetType1Capacity              | 1000000                  |
    Then op create the suggested route
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator V2 clean up 'Route Groups'

  Scenario: Download same day route engine csv export (uid:5247e84e-d36d-4ddd-96db-63b5fddfee77)
    Given Operator go to menu Shipper Support -> Blocked Dates
    #Notes: Shipper create C2C Bulky parcel with OC V2
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "parcels":[{ "parcel_size_id":0, "volume":1, "weight":4, "bulky_job":{ "installation_required":true, "flight_of_stairs":1, "sku":"AUTOMATA1" }}], "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    #Create another order that outside the operating hour
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "parcels":[{ "parcel_size_id":0, "volume":1, "weight":4, "bulky_job":{ "installation_required":true, "flight_of_stairs":1, "sku":"AUTOMATA1" }}], "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 23:15:00", "delivery_reach_by":"{{cur_date}} 23:30:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transactions to Route Group
    Given Operator go to menu Routing -> 5. Route Engine - Same-Day Route Engine
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
      | fleetType1Capacity              | 1000000                  |
    Then op open same day route engine waypoint detail dialog
    Then op download same day route engine waypoint detail dialog
    Then Operator V2 clean up 'Route Groups'

  Scenario: Check unrouted detail (uid:6b5fa949-deba-41c1-b9e1-0c77e605832b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    #Notes: Shipper create C2C Bulky parcel with OC V2
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "parcels":[{ "parcel_size_id":0, "volume":1, "weight":4, "bulky_job":{ "installation_required":true, "flight_of_stairs":1, "sku":"AUTOMATA1" }}], "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    #Create another order that outside the operating hour
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "parcels":[{ "parcel_size_id":0, "volume":1, "weight":4, "bulky_job":{ "installation_required":true, "flight_of_stairs":1, "sku":"AUTOMATA1" }}], "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 23:15:00", "delivery_reach_by":"{{cur_date}} 23:30:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transactions to Route Group
    Given Operator go to menu Routing -> 5. Route Engine - Same-Day Route Engine
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 1500 hrs                 |
      | fleetType1Capacity              | 10000                    |
    When op open unrouted detail dialog
    Then op verify the unrouted detail dialog
    Then Operator V2 clean up 'Route Groups'

  Scenario: Update timeslot for bulky parcels (uid:154a1482-33e2-4fff-9a99-ed6a96b289be)
    Given Operator go to menu Shipper Support -> Blocked Dates
    #Notes: Shipper create C2C Bulky parcel with OC V2
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "parcels":[{ "parcel_size_id":0, "volume":1, "weight":4, "bulky_job":{ "installation_required":true, "flight_of_stairs":1, "sku":"AUTOMATA1" }}], "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | false |
    When Operator go to menu Routing -> 2. Route Group Management
    Then Operator wait until 'Route Group' page is loaded
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator V2 add created Transactions to Route Group
    Given Operator go to menu Routing -> 5. Route Engine - Same-Day Route Engine
    When op 'Run Route Engine' on Same-Day Route Engine menu using data below:
      | hub                             | 30JKB                    |
      | routingAlgorithm                | Bulky Pickup/Delivery    |
      | fleetType1OperatingHoursStart   | 0900 hrs                 |
      | fleetType1OperatingHoursEnd     | 2300 hrs                 |
      | fleetType1BreakingDurationStart | 1200 hrs                 |
      | fleetType1BreakingDurationEnd   | 1300 hrs                 |
      | fleetType1Capacity              | 1000000                  |
    Then op open same day route engine waypoint detail dialog
    When op update timeslot on same day route engine
    Then op verify the updated timeslot
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
