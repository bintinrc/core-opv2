@Sort @Sort @HubUserManagementPart2
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with client id = "{sort-hub-user-client-id}" and client secret = "{sort-hub-user-client-secret}"

  Scenario: Hub User Management -  manager to switch between hubs in station users page - Managers Assigned only 1 Hubs
    When Operator go to menu Sort -> Hub User Management
    Then Operator verifies redirect to correct "{station-hub-name-1}" Hub User Management Page
