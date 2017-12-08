@OperatorV2 @RouteGroups
Feature: Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete 'route group' on 'Route Groups'. (uid:21c16416-b5c7-40c9-adb1-98c37bdf820f)
    Given Operator go to menu Routing -> 2. Route Group Management
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | true |
    Given Operator go to menu Routing -> 2. Route Group Management
    Then new 'route group' on 'Route Groups' created successfully
    When op update 'route group' on 'Route Groups'
    Then 'route group' on 'Route Groups' updated successfully
    When op delete 'route group' on 'Route Groups'
    Then 'route group' on 'Route Groups' deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
