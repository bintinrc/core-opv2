@DpCompanyManagement @selenium
Feature: DP Company Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete DP Company (uid:97fa4e10-b3cc-4f81-975c-175c7ed57e82)
    Given op click navigation DP Company Management in Distribution Points
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator update the new DP Company
    Then Operator verify the new DP Company is updated successfully
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  Scenario: Operator download and verify DP Company CSV file (uid:7bc46cd1-f8c3-48a5-aa03-bede2a999334)
    Given op refresh page
    Given op click navigation DP Company Management in Distribution Points
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator download DP Company CSV file
    Then Operator verify DP Company CSV file downloaded successfully
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  Scenario: Operator create, update and delete agent on DP Company (uid:3ca789ab-8a6d-4114-8adc-6bfb058e8c7b)
    Given op refresh page
    Given op click navigation DP Company Management in Distribution Points
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator create new Agent for the new DP Company
    Then Operator verify the new Agent for the new DP Company is created successfully
#    When Operator update the new Agent for the new DP Company
#    Then Operator verify the new Agent for the new DP Company is updated successfully
#    When Operator delete the new Agent for the new DP Company
#    Then Operator verify the new Agent for the new DP Company is deleted successfully
    When Operator back to DP Company Management page
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  @KillBrowser
  Scenario: Kill Browser
