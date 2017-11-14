@DpCompanyManagement @selenium
Feature: DP Company Management

  @LaunchBrowser @DpCompanyManagement#01 @DpCompanyManagement#02 @DpCompanyManagement#03 @DpCompanyManagement#04
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @DpCompanyManagement#01
  Scenario: Operator create, update and delete DP Company (uid:97fa4e10-b3cc-4f81-975c-175c7ed57e82)
    Given op click navigation DP Company Management in Distribution Points
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator update the new DP Company
    Then Operator verify the new DP Company is updated successfully
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  @DpCompanyManagement#02
  Scenario: Operator check all filters on DP Company Management page work fine (uid:0607f541-8d36-4851-a420-fe3ebf36d641)
    Given op refresh page
    Given op click navigation DP Company Management in Distribution Points
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    And Operator check all filters on DP Company Management page work fine
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  @DpCompanyManagement#03
  Scenario: Operator download and verify DP Company CSV file (uid:7bc46cd1-f8c3-48a5-aa03-bede2a999334)
    Given op refresh page
    Given op click navigation DP Company Management in Distribution Points
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator download DP Company CSV file
    Then Operator verify DP Company CSV file downloaded successfully
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  @DpCompanyManagement#04
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

  @KillBrowser @DpCompanyManagement#01 @DpCompanyManagement#02 @DpCompanyManagement#03 @DpCompanyManagement#04
  Scenario: Kill Browser
