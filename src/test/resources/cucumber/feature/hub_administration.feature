@HubAdministration @selenium @saas
Feature: hubs administration

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  # download hub list
  Scenario: download hub list (uid:2a3dd749-c251-45a7-893b-84b8611f5665)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration download button is clicked
    Then hubs administration file should exist

  # add hub
  Scenario: add hub (uid:c753d5ed-1026-408e-9c71-0e5b8f4e7aa3)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration add button is clicked
    When hubs administration enter default value
    Then hubs administration verify result add

  # search hub
  Scenario: search hub (uid:94222294-3788-453b-90c4-86f9bd751641)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration searching for hub

  # edit hub
  Scenario: edit hub (uid:aca32744-d848-4506-a5f0-b2736dc19987)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration searching for hub
    When hubs administration edit button is clicked
    Then hubs administration verify result edit

  @closeBrowser
  Scenario: close browser