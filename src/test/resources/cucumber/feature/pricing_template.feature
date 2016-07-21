@selenium @wip
Feature: Pricing Template

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administration

  Scenario: Operator create, update and delete rules on Pricing Template menu.
    Given op click navigation Pricing Template
    When op create new rules on Pricing Template
    Then new rules on Pricing Template created successfully
    When op update rules on Pricing Template
    Then rules on Pricing Template updated successfully
    When op delete rules on Pricing Template
    Then rules on Pricing Template deleted successfully

  Scenario: Operator
    Given op click navigation Pricing Template
    Given op have two default rules "PT Cucumber Test 1" and "PT Cucumber Test 2"
    When do nothing
    Then do something

  @closeBrowser
  Scenario: op logout from operator portal
    Given op click navigation DP Administration
    When logout button is clicked
    Then op back in the login page