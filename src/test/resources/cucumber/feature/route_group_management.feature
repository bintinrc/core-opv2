@OperatorV2 @OperatorV2Part1 @RouteGroups @Saas
Feature: Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create, update and delete 'route group' on 'Route Group Management' (uid:9c3eb32c-df35-4bb6-a53c-b741751c7971)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully
    When Operator update 'Route Group' on 'Route Group Management'
    Then Operator verify 'Route Group' on 'Route Group Management' updated successfully
    When Operator delete 'Route Group' on 'Route Group Management'
    Then Operator verify 'Route Group' on 'Route Group Management' deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
