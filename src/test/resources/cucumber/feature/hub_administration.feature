@selenium
Feature: hubs administration

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administration

  # download hub list
  Scenario: op download hub csv list
    Given op click navigation Hubs Administration
    When hubs administration download button is clicked
    Then hubs administration file should exist

  # add hub
  Scenario: op add hub
    Given op click navigation Hubs Administration
    When hubs administration add button is clicked
    When hubs administration enter default value
    Then hubs administration verify result add

  # search hub
  Scenario: op searching for hub
    Given op click navigation Hubs Administration
    When hubs administration searching for hub

  # edit hub
  Scenario: op edit existing hub
    Given op click navigation Hubs Administration
    When hubs administration searching for hub
    When hubs administration edit button is clicked
    Then hubs administration verify result edit

  @closeBrowser
  Scenario: close browser