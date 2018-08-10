@OperatorV2 @OperatorV2Part2 @CreateRouteGroups @Saas
Feature: Transactions

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add transaction to Route Group (uid:b6848852-12e6-4cba-bf7c-8444538596c1)
    #Notes: Shipper create sameday parcel with OC V2
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    When Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator wait until 'Create Route Group' page is loaded
    When Operator V2 add created Transaction to Route Group
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator V2 clean up 'Route Groups'

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
