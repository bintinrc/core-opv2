@OperatorV2 @OperatorV2Part1 @HubGroupsManagement @CWF @SIT
Feature: Hubs Group Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsGroup
  Scenario: Operator should be able to create a new Hub Group on page Hubs Group Management (uid:43fb4361-de65-4b31-bcef-71b6f99bcf39)
    Given Operator go to menu Hubs -> Hubs Group Management
    When Operator create new Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
      | hubs | {hub-name},{hub-name-2} |
    Then Operator verify created Hubs Group properties on Hubs Group Management page

  @DeleteHubsGroup
  Scenario: Operator should be able to update Hub Group on page Hubs Group Management (uid:74108a28-ca4a-412f-ac79-0cc4ccedbf39)
    Given Operator go to menu Hubs -> Hubs Group Management
    When Operator create new Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
      | hubs | {hub-name},{hub-name-2} |
    Then Operator verify created Hubs Group properties on Hubs Group Management page
    When Operator update created Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
    Then Operator verify created Hubs Group properties on Hubs Group Management page

  @DeleteHubsGroup
  Scenario: Operator should be able to delete Hub Group on page Hubs Group Management (uid:d9896041-c1bb-4804-b007-91b226821570)
    Given Operator go to menu Hubs -> Hubs Group Management
    When Operator create new Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
      | hubs | {hub-name},{hub-name-2} |
    Then Operator verify created Hubs Group properties on Hubs Group Management page
    And Operator refresh page
    When Operator delete created Hub Group on Hubs Group Management page
    And Operator refresh page
    Then Operator verify created Hub Group was deleted successfully on Hubs Group Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
