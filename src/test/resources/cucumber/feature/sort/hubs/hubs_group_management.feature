@Sort @Hubs @HubGroupsManagement
Feature: Hubs Group Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsGroup
  Scenario: Create Hub Group (uid:9edb47f9-2b2c-4b12-99c5-b6ea146b8885)
    Given Operator go to menu Hubs -> Hubs Group Management
    When Operator create new Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
      | hubs | {hub-name},{hub-name-2} |
    Then Operator verify created Hubs Group properties on Hubs Group Management page

  @DeleteHubsGroup
  Scenario: Edit Hub Group (uid:a0e98d49-f1a4-4de9-b62d-eda99d643304)
    Given Operator go to menu Hubs -> Hubs Group Management
    When Operator create new Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
      | hubs | {hub-name},{hub-name-2} |
    Then Operator verify created Hubs Group properties on Hubs Group Management page
    When Operator update created Hub Group on Hubs Group Management page using data below:
      | name | GENERATED |
    Then Operator verify created Hubs Group properties on Hubs Group Management page

  @DeleteHubsGroup
  Scenario: Delete Hub Group (uid:06488277-923e-403f-b1f6-e312826761e7)
    Given Operator go to menu Hubs -> Hubs Group Management
    When Operator create new Hub Group on Hubs Group Management page using data below:
      | name | GENERATED               |
      | hubs | {hub-name},{hub-name-2} |
    Then Operator verify created Hubs Group properties on Hubs Group Management page
    And Operator refresh page
    When Operator delete created Hub Group on Hubs Group Management page
    And Operator refresh page
    Then Operator verify created Hub Group was deleted successfully on Hubs Group Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
