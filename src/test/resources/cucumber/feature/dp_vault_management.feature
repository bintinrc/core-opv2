@OperatorV2Disabled @DpVaultManagement
Feature: DP Vault Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create, update and delete DP Vault (uid:73a1d6e2-9265-4031-bcae-fd615a3c1fad)
    Given Operator go to menu "Distribution Points" -> "DP Vault Management"
    When Operator create new DP Vault using DP "Automation Station DP #1"
    When Operator refresh page
    Then Operator verify the new DP Vault is created successfully
    When Operator delete the new DP Vault
    Then Operator verify the new DP Vault is deleted successfully

  Scenario: Operator check all filters on DP Vault Management page work fine (uid:4f82045e-9807-4c82-946c-b4c420c6c5a7)
    Given Operator refresh page
    Given Operator go to menu "Distribution Points" -> "DP Vault Management"
    When Operator create new DP Vault using DP "Automation Station DP #1"
    When Operator refresh page
    Then Operator verify the new DP Vault is created successfully
    And Operator check all filters on DP Vault Management page work fine
    When Operator delete the new DP Vault
    Then Operator verify the new DP Vault is deleted successfully

  Scenario: Operator download and verify DP Vault CSV file (uid:66e2c471-e071-46f3-abfb-2898ab9c4afb)
    Given Operator refresh page
    Given Operator go to menu "Distribution Points" -> "DP Vault Management"
    When Operator create new DP Vault using DP "Automation Station DP #1"
    When Operator refresh page
    Then Operator verify the new DP Vault is created successfully
    When Operator download DP Vault CSV file
    Then Operator verify DP Vault CSV file downloaded successfully
    When Operator delete the new DP Vault
    Then Operator verify the new DP Vault is deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
