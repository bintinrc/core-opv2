@TagManagement @selenium
Feature: Tag Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete tag on Tag Management menu. (uid:a49a930e-1fb2-4a0c-8a8f-8bbccc5d87cc)
    Given op click navigation Tag Management in Routing
    When op create new tag on Tag Management
    Then new tag on Tag Management created successfully
    When op update tag on Tag Management
    Then tag on Tag Management updated successfully
    When op delete tag on Tag Management
    Then tag on Tag Management deleted successfully

  @KillBrowser
  Scenario: Kill Browser
