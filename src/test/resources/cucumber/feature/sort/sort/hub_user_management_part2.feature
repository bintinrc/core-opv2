@Sort @Sort @HubUserManagement
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Hub User Management -  manager to switch between hubs in station users page - Managers Assigned only 1 Hubs
    When Operator go to menu Sort -> Hub User Management
    Then Operator verifies redirect to correct "{station-hub-name-1}" Hub User Management Page
