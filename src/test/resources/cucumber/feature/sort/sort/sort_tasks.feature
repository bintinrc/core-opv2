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
    And API Operator create Middle Tier sort node:
      | hub_id | {hub-id}                                             |
      | name   | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator open the sidebar menu on Sort Tasks page
    When Operator delete the middle tier
    Then Operator verifies that "Middle Tier Deleted" success notification is displayed
    And Operator verify middle tier is deleted

  @DeleteNodes
  Scenario: Add a sort task (uid:dace248c-a773-46f2-888f-c23385354e34)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create Middle Tier sort node:
      | hub_id | {hub-id}                                             |
      | name   | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator select a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator refresh table on Sort Tasks page
    Then Operator verify added outputs appears on tree list

  @DeleteNodes
  Scenario: Removing a sort task (uid:5691e165-f0c7-4ecd-a255-294b7d095f17)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create Middle Tier sort node:
      | hub_id | {hub-id}                                             |
      | name   | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
      | hubId   | {hub-id}   |
    And Operator open the sidebar menu on Sort Tasks page
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
  Scenario: Search sort nodes on Sort Structure Page (uid:7266300d-faed-4254-9b5a-d68ec8e51991)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {hub-name-4}  |
      | SORT-SG-2-HUB |
    And Operator verifies graph contains following Middle Tier nodes:
      | {mid-tier-name} |
    And Operator verifies graph contains following Zone nodes:
      | SORT-1 |
    And Operator verifies graph contains following duplicated nodes:
      | label  | count |
      | SORT-1 | 2     |
    When Operator search for "{mid-tier-name}" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name-4}    |
      | {mid-tier-name} |
      | SORT-1          |
      | SORT-SG-2-HUB   |

  @CloseNewWindows
  Scenario: Click on nodes (uid:ff4c25d4-25c0-466c-8bd0-ce5ceb0e0036)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {hub-name-4}  |
      | SORT-SG-2-HUB |
    And Operator verifies graph contains following Middle Tier nodes:
      | {mid-tier-name} |
    And Operator verifies graph contains following Zone nodes:
      | SORT-1 |
    And Operator verifies graph contains following duplicated nodes:
      | label  | count |
      | SORT-1 | 2     |
    When Operator search for "{mid-tier-name}" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name-4}    |
      | {mid-tier-name} |
      | SORT-1          |
      | SORT-SG-2-HUB   |
    When Operator clicks on "{mid-tier-name}" node
    Then Operator verifies graph contains exactly following nodes:
      | {mid-tier-name} |
      | SORT-1          |
      | SORT-SG-2-HUB   |

  @CloseNewWindows @DeleteNodes
  Scenario: Refresh Diagram - Add new nodes (uid:0ac79364-da2a-4a10-b310-0cfed70b1642)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create Middle Tier sort node:
      | hub_id | {hub-id-4}                                           |
      | name   | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name} |
    When Operator switch to Sort Tasks window
    And Operator open the sidebar menu on Sort Tasks page
    And Operator select a sort task
    Then Operator verifies that "{hub-name-4} modified" success notification is displayed
    When Operator switch to View Sort Structure window
    And Operator refresh diagram on View Sort Structure page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name}                |
      | {KEY_CREATED_MIDDLE_TIER_NAME} |

  @CloseNewWindows @DeleteNodes
  Scenario: Refresh Diagram - Update the middle tier name (uid:e6904a0c-7c05-45ff-8a2b-b54a0eb77641)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
      | hubId   | {hub-id-4}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIER{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator select a sort task
    Then Operator verifies that "{hub-name-4} modified" success notification is displayed
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name}                |
      | {KEY_CREATED_MIDDLE_TIER_NAME} |
    When Operator switch to Sort Tasks window
    And Operator update name of "{KEY_CREATED_MIDDLE_TIER_NAME}" Middle Tire to "EDITED{KEY_CREATED_MIDDLE_TIER_NAME}" on Sort Tasks page
    Then Operator verifies that "Middle Tier Renamed" success notification is displayed
    When Operator switch to View Sort Structure window
    And Operator refresh diagram on View Sort Structure page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name}                      |
      | EDITED{KEY_CREATED_MIDDLE_TIER_NAME} |

  @CloseNewWindows @DeleteNodes
  Scenario: Refresh Diagram - Delete nodes (uid:0f299ec0-fea8-437d-bd6b-85b32d2b0646)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
      | hubId   | {hub-id-4}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIER{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator select a sort task
    Then Operator verifies that "{hub-name-4} modified" success notification is displayed
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name}                |
      | {KEY_CREATED_MIDDLE_TIER_NAME} |
    When Operator switch to Sort Tasks window
    And Operator open the sidebar menu on Sort Tasks page
    When Operator delete the middle tier
    Then Operator verifies that "Middle Tier Deleted" success notification is displayed
    When Operator switch to View Sort Structure window
    And Operator refresh diagram on View Sort Structure page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name} |

  @CloseNewWindows
  Scenario: Reset View (uid:25e340fb-a5e5-482f-996e-804617fff83d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
    And Operator click View Sort Structure on Sort Tasks page
    When Operator search for "SORT-SG-2-HUB" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name-4}    |
      | {mid-tier-name} |
      | SORT-SG-2-HUB   |
    When Operator reset view on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name-4}    |
      | {mid-tier-name} |
      | SORT-1          |
      | SORT-1          |
      | SORT-SG-2-HUB   |

  Scenario: Searches parent node (uid:0761b4db-c350-4629-86c9-91cffd672f69)
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
    And Operator search for "{hub-name-4}" node on Sort Tasks page
    Then Operator verify displayed nodes on Sort Tasks page:
      | {hub-name-4} |
    And Operator verify following nodes are highlighted on Sort Tasks page:
      | {hub-name-4} |

  Scenario: Searches child node (uid:380f6bb5-4538-48bc-9699-cbcc7af3b987)
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-4} |
    And Operator search for "{mid-tier-name}" node on Sort Tasks page
    Then Operator verify displayed nodes on Sort Tasks page:
      | {hub-name-4}    |
      | {mid-tier-name} |
      | SORT-1          |
    And Operator verify following nodes are highlighted on Sort Tasks page:
      | {mid-tier-name} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op