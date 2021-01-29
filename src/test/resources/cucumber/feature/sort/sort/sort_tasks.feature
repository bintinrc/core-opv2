@Sort @SortTask
Feature: Sort Task

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNodes
  Scenario: Create New Mid Tier (uid:acf7e253-bcd5-4dd8-a65f-4a5b5d7533d1)
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator verify new middle tier is created
      | hubName  | {hub-name}  |
      | sortType | MIDDLE TIER |

  @DeleteNodes
  Scenario: Delete Middle Tier (uid:740f8475-5447-4af5-89d9-7adae3170d83)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator verify new middle tier is created
      | hubName  | {hub-name}  |
      | sortType | MIDDLE TIER |
    When Operator delete the middle tier
    Then Operator verifies that "Middle Tier Deleted" success notification is displayed
    And Operator verify middle tier is deleted

  @DeleteNodes
  Scenario: Add a sort task (uid:dace248c-a773-46f2-888f-c23385354e34)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator select a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator refresh table on Sort Tasks page
    Then Operator verify added outputs appears on tree list

  @DeleteNodes
  Scenario: Removing a sort task (uid:5691e165-f0c7-4ecd-a255-294b7d095f17)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator select a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator refresh table on Sort Tasks page
    Then Operator verify added outputs appears on tree list
    When Operator open the sidebar menu on Sort Tasks page
    And Operator remove selection of a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator refresh table on Sort Tasks page
    Then Operator verify removed outputs removed on tree list

  @CloseNewWindows
  Scenario: Search sort nodes on Sort Structure Page
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {hub-name}    |
      | SORT-SG-2-HUB |
    And Operator verifies graph contains following Middle Tier nodes:
      | MID-TEST-NIKO |
    And Operator verifies graph contains following Zone nodes:
      | SORT-1 |
    And Operator verifies graph contains following duplicated nodes:
      | label  | count |
      | SORT-1 | 2     |
    When Operator search for "MID-TEST-NIKO" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name}    |
      | MID-TEST-NIKO |
      | SORT-1        |
      | SORT-SG-2-HUB |

  @CloseNewWindows
  Scenario: Click on nodes (uid:ff4c25d4-25c0-466c-8bd0-ce5ceb0e0036)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {hub-name}    |
      | SORT-SG-2-HUB |
    And Operator verifies graph contains following Middle Tier nodes:
      | MID-TEST-NIKO |
    And Operator verifies graph contains following Zone nodes:
      | SORT-1 |
    And Operator verifies graph contains following duplicated nodes:
      | label  | count |
      | SORT-1 | 2     |
    When Operator search for "MID-TEST-NIKO" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name}    |
      | MID-TEST-NIKO |
      | SORT-1        |
      | SORT-SG-2-HUB |
    When Operator clicks on "MID-TEST-NIKO" node
    Then Operator verifies graph contains exactly following nodes:
      | MID-TEST-NIKO |
      | SORT-1        |
      | SORT-SG-2-HUB |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op