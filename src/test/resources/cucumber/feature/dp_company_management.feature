@OperatorV2Disabled @DpCompanyManagement
Feature: DP Company Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create, update and delete DP Company (uid:97fa4e10-b3cc-4f81-975c-175c7ed57e82)
    Given Operator go to menu Distribution Points -> DP Company Management
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator update the new DP Company
    Then Operator verify the new DP Company is updated successfully
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  Scenario: Operator check all filters on DP Company Management page work fine (uid:0607f541-8d36-4851-a420-fe3ebf36d641)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Company Management
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    And Operator check all filters on DP Company Management page work fine
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  Scenario: Operator download and verify DP Company CSV file (uid:7bc46cd1-f8c3-48a5-aa03-bede2a999334)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Company Management
    When Operator create new DP Company
    Then Operator verify the new DP Company is created successfully
    When Operator download DP Company CSV file
    Then Operator verify DP Company CSV file downloaded successfully
    When Operator delete the new DP Company
    Then Operator verify the new DP Company is deleted successfully

  Scenario: Operator create, update and delete agent on DP Company (uid:3ca789ab-8a6d-4114-8adc-6bfb058e8c7b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Distribution Points -> DP Company Management
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
