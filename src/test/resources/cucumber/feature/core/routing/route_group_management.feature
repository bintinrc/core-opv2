@OperatorV2 @Core @Routing @RouteGroupManagement
Feature: Route Group Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Creates Route Group (uid:1b4f68cf-074d-420d-9d61-cd690f47d02b)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully

  Scenario: Operator Updates Route Group Details (uid:1eed4c03-b980-47b2-9816-8530890a996e)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully
    When Operator update 'Route Group' on 'Route Group Management'
    Then Operator verify 'Route Group' on 'Route Group Management' updated successfully

  Scenario: Operator Deletes Route Group (uid:b26dcd98-2fb0-418a-8903-ffcdf911c416)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully
    When Operator delete 'Route Group' on 'Route Group Management'
    Then Operator verify 'Route Group' on 'Route Group Management' deleted successfully

  Scenario: Delete Transactions From Route Group (uid:92fed5ab-78c7-4fc8-95d3-5ea1e19f6580)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator wait until 'Create Route Group' page is loaded
    When Operator V2 add created Transaction to Route Group
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator delete created delivery transaction from route group

  Scenario: Bulk Delete Route Groups (uid:de12c7a6-b147-4303-92c2-5b4f3f9bfa0f)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    And Operator go to menu Routing -> 2. Route Group Management
    And Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    And Operator go to menu Routing -> 2. Route Group Management
    And Operator wait until 'Route Group Management' page is loaded
    When Operator delete created Route Groups on 'Route Group Management' page using password "1234567890"
    Then Operator verify created Route Groups on 'Route Group Management' deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op