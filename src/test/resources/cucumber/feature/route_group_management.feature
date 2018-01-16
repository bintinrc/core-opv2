@OperatorV2 @RouteGroups
Feature: Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete 'route group' on 'Route Group Management'. (uid:21c16416-b5c7-40c9-adb1-98c37bdf820f)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'route group' on 'Route Groups' using data below:
      | generateName | true |
    Given Operator go to menu Routing -> 2. Route Group Management
    Then Operator verify new 'route group' on 'Route Groups' created successfully
    When Operator update 'route group' on 'Route Group Management'
    Then Operator verify 'route group' on 'Route Group Management' updated successfully
    When Operator delete 'route group' on 'Route Group Management'
    Then Operator verify 'route group' on 'Route Group Management' deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
