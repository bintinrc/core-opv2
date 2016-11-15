@selenium @TagManagement
Feature: Tag Management

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  Scenario: Operator create, update and delete tag on Tag Management menu. (uid:a49a930e-1fb2-4a0c-8a8f-8bbccc5d87cc)
    Given op click navigation Tag Management in Routing
    When op create new tag on Tag Management
    Then new tag on Tag Management created successfully
    When op update tag on Tag Management
    Then tag on Tag Management updated successfully
    When op delete tag on Tag Management
    Then tag on Tag Management deleted successfully

  @closeBrowser
  Scenario: close browser