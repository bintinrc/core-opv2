@NinjaChat
Feature: OPv2 - Live Agent Overview

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ui
  Scenario: Add Live Agent to List of Admin
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    Then Create live agent with email and username
    And Verify agent added successfully

  @ui
  Scenario: Update Live Agent to List of Admin
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    Then Update live agent with email and username
    Then Verify agent added successfully

  @ui
  Scenario: Remove Live Agent to List of Admin
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    Then Create live agent with email and username
    Then Delete live agent
    Then Verify agent deleted successfully

  @ui
  Scenario: Read List of Admin
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    Then Verify agent list is visible

  @ui
  Scenario: Manage Live Agent Operational Hour
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    When Open holidays popup
    Then Verify operating hour modal
    When Save operating hour modal and verify modal closes
      | top | Operating hours and holidays updated |


  @ui
  Scenario: Add Same Shipper Support Live Agent to Shipper Support Live Agent
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    And Goto "Shipper support" section
    Then Delete live agent with name "QA Automation tester"
    Then Verify agent deleted successfully with name "QA Automation tester"
    Then Create live agent with email and username with below data:
      | fullName | QA Automation tester   |
      | email    | ninjavan.qa3@gmail.com |
    Then Verify agent added successfully

  @ui
  Scenario: Add Same Customer Support Live Agent to Shipper Support Live Agent
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    Then Delete live agent with name "QA Automation tester - 1"
    Then Verify agent deleted successfully with name "QA Automation tester - 1"
    And Goto "Shipper support" section
    Then Create live agent with email and username with below data:
      | fullName | QA Automation tester - 1 |
      | email    | ninjavan.qa4@gmail.com   |
    Then Verify agent added successfully
    Then Delete live agent with name "QA Automation tester - 1"
    Then Verify agent deleted successfully with name "QA Automation tester - 1"
    And Goto "Customer support" section
    Then Create live agent with email and username with below data:
      | fullName | QA Automation tester - 1 |
      | email    | ninjavan.qa4@gmail.com   |
    Then Verify agent added successfully

  @ui
  Scenario: Add Same Shipper Support Live Agent to Customer Support Live Agent
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    And Goto "Shipper support" section
    Then Delete live agent with name "QA Automation tester - 2"
    Then Verify agent deleted successfully with name "QA Automation tester - 2"
    And Goto "Customer support" section
    Then Create live agent with email and username with below data:
      | fullName | QA Automation tester - 2 |
      | email    | ninjavan.qa5@gmail.com   |
    Then Verify agent added successfully
    Then Delete live agent with name "QA Automation tester - 2"
    Then Verify agent deleted successfully with name "QA Automation tester - 2"
    And Goto "Shipper support" section
    Then Create live agent with email and username with below data:
      | fullName | QA Automation tester - 2 |
      | email    | ninjavan.qa5@gmail.com   |
    Then Verify agent added successfully

  @ui
  Scenario: Add Same Customer Support Live Agent to Customer Support Live Agent
    Given Operator go to menu Customer Experience -> Live Chat Admin Dashboard
    Then Delete live agent with name "QA Automation tester - 1"
    Then Verify agent deleted successfully with name "QA Automation tester - 1"
    Then Create live agent with email and username with below data:
      | fullName | QA Automation tester - 1 |
      | email    | ninjavan.qa4@gmail.com   |
    Then Verify agent added successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op


