@HubAdministration @selenium @saas
Feature: Hubs Administration

  @LaunchBrowser @HubAdministration#01
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @HubAdministration#01
  Scenario: download hub list (uid:2a3dd749-c251-45a7-893b-84b8611f5665)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration download button is clicked
    Then hubs administration file should exist

  @HubAdministration#01
  Scenario: add hub (uid:c753d5ed-1026-408e-9c71-0e5b8f4e7aa3)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration add button is clicked
    When hubs administration enter default value
    Then hubs administration verify result add

  @HubAdministration#01
  Scenario: search hub (uid:94222294-3788-453b-90c4-86f9bd751641)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration searching for hub

  @HubAdministration#01
  Scenario: edit hub (uid:aca32744-d848-4506-a5f0-b2736dc19987)
    Given op click navigation Hubs Administration in Hubs
    When hubs administration searching for hub
    When hubs administration edit button is clicked
    Then hubs administration verify result edit

  @KillBrowser @HubAdministration#01
  Scenario: Kill Browser
