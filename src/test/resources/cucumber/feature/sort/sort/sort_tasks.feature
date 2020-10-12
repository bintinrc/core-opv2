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

  @CloseNewWindows
  Scenario: Removing a sort task (uid:5691e165-f0c7-4ecd-a255-294b7d095f17)
    Given Operator go to menu Sort -> Sort Tasks
    When Operator select the hub in the Hub dropdown menu
      | hubName  | {hub-name}   |
    And Operator open the sidebar menu
    And Operator open create new middle tier
      | name     | GENERATED    |
    Then Operator verify success create new mid tier toast is shown
      And Operator select a sort task
    Then Operator verify success modified toast is shown
    When Operator refresh page
    When Operator select the hub in the Hub dropdown menu
      | hubName  | {hub-name}   |
    And Operator verify added outputs appears on tree list

  @CloseNewWindows
  Scenario: Add a sort task (uid:dace248c-a773-46f2-888f-c23385354e34)
    Given Operator go to menu Sort -> Sort Tasks
    When Operator select the hub in the Hub dropdown menu
      | hubName  | {hub-name}   |
    And Operator open the sidebar menu
    And Operator open create new middle tier
      | name     | GENERATED    |
    Then Operator verify success create new mid tier toast is shown
    And Operator select a sort task
    Then Operator verify success modified toast is shown
    And Operator open the sidebar menu
    And Operator select a sort task
    Then Operator verify success modified toast is shown
    When Operator refresh page
    When Operator select the hub in the Hub dropdown menu
      | hubName  | {hub-name}   |
    Then Operator verify removed outputs removed on tree list

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op