@TagManagement @selenium
Feature: Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete tag on Tag Management menu. (uid:a49a930e-1fb2-4a0c-8a8f-8bbccc5d87cc)
    Given Operator V2 cleaning Tag Management by calling API endpoint directly
    Given Operator go to menu Routing -> Tag Management
    When op create new tag on Tag Management
    Then new tag on Tag Management created successfully
    When op update tag on Tag Management
    Then tag on Tag Management updated successfully
    Then Operator V2 cleaning Tag Management by calling API endpoint directly
# This 2 steps below is removed because KH said the ops want that button to be removed.
#    When op delete tag on Tag Management
#    Then tag on Tag Management deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
