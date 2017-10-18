@DpCompanyManagement @selenium
Feature: DP Company Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Create new DP Company
    Given op click navigation DP Company Management in Distribution Points
    When Operator add new DP Company
    Then Operator verify the new DP Company is created successfully

  @KillBrowser
  Scenario: Kill Browser
