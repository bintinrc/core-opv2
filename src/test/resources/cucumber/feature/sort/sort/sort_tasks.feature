@Sort @SortTask
Feature: Sort Task

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Create New Mid Tier (uid:acf7e253-bcd5-4dd8-a65f-4a5b5d7533d1)
    Given Operator go to menu Sort -> Sort Tasks
    When Operator select the hub in the Hub dropdown menu
      | hubName  | {hub-name}   |
    And Operator open the sidebar menu
    And Operator open create new middle tier
      | name     | GENERATED    |
    Then Operator verify success create new mid tier toast is shown
    And Operator verify new middle tier is created
      | hubName  | {hub-name}   |
      | sortType | MIDDLE TIER  |

  @CloseNewWindows
  Scenario: Delete Middle Tier (uid:740f8475-5447-4af5-89d9-7adae3170d83)
    Given Operator go to menu Sort -> Sort Tasks
    When Operator select the hub in the Hub dropdown menu
      | hubName  | {hub-name}   |
    And Operator open the sidebar menu
    And Operator open create new middle tier
      | name     | GENERATED    |
    Then Operator verify success create new mid tier toast is shown
    And Operator verify new middle tier is created
      | hubName  | {hub-name}   |
      | sortType | MIDDLE TIER  |
    When Operator delete the middle tier
    Then Operator verify success delete mid tier toast is shown
    And Operator verify middle tier is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op