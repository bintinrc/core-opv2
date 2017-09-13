@RouteGroups @selenium
Feature: Route Groups

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete 'route group' on 'Route Groups'. (uid:21c16416-b5c7-40c9-adb1-98c37bdf820f)
    Given op click navigation 2. Route Group Management in Routing
    When op create new 'route group' on 'Route Groups' using data below:
      | generateName | true |
    Given op click navigation 2. Route Group Management in Routing
    Then new 'route group' on 'Route Groups' created successfully
    When op update 'route group' on 'Route Groups'
    Then 'route group' on 'Route Groups' updated successfully
    When op delete 'route group' on 'Route Groups'
    Then 'route group' on 'Route Groups' deleted successfully

  @KillBrowser
  Scenario: Kill Browser
