@Sort @SortTaskPart2
Feature: Sort Task

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteNodes
  Scenario: Refresh Diagram - Add new nodes (uid:0ac79364-da2a-4a10-b310-0cfed70b1642)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create Middle Tier sort node:
      | hub_id | {hub-id-5}                                           |
      | name   | MIDTIERDONOTUSE{gradle-current-date-yyyyMMddHHmmsss} |
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-5} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name} |
    When Operator switch to Sort Tasks window
    And Operator open the sidebar menu on Sort Tasks page
    And Operator select a sort task
    Then Operator verifies that "{hub-name-5} modified" success notification is displayed
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
      | {mid-tier-name}                |
      | {KEY_CREATED_MIDDLE_TIER_NAME} |

  @CloseNewWindows @DeleteNodes
  Scenario: Refresh Diagram - Delete nodes (uid:0f299ec0-fea8-437d-bd6b-85b32d2b0646)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-5} |
      | hubId   | {hub-id-5}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator creates new middle tier on Sort Tasks page
      | name | MIDTIER{gradle-current-date-yyyyMMddHHmmsss} |
    Then Operator verifies that "New Middle Tier Created" success notification is displayed
    And Operator select a sort task
    Then Operator verifies that "{hub-name-5} modified" success notification is displayed
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name}                |
      | {KEY_CREATED_MIDDLE_TIER_NAME} |
    When Operator switch to Sort Tasks window
    And Operator open the sidebar menu on Sort Tasks page
    When Operator delete the middle tier
    Then Operator verifies that "Middle Tier Deleted" success notification is displayed
    When Operator switch to View Sort Structure window
    Then Operator verifies graph contains exactly following Middle Tier nodes:
      | {mid-tier-name} |

  @CloseNewWindows
  Scenario: Reset View (uid:25e340fb-a5e5-482f-996e-804617fff83d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {sort-task-hub} |
    And Operator click View Sort Structure on Sort Tasks page
    When Operator search for "{sort-task-next-hub}" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {sort-task-hub}      |
      | {sort-task-next-hub} |
    When Operator reset view on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {sort-task-hub}         |
      | {sort-task-next-hub}    |
      | {sort-task-middle-tier} |
      | {sort-task-zone}        |
      | {sort-task-zone}        |

  Scenario: Searches parent node (uid:0761b4db-c350-4629-86c9-91cffd672f69)
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {sort-task-hub} |
    And Operator search for "{sort-task-hub}" node on Sort Tasks page
    Then Operator verify displayed nodes on Sort Tasks page:
      | {sort-task-hub} |
    And Operator verify following nodes are highlighted on Sort Tasks page:
      | {sort-task-hub} |

  Scenario: Searches child node (uid:380f6bb5-4538-48bc-9699-cbcc7af3b987)
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {sort-task-hub} |
    And Operator search for "{sort-task-zone}" node on Sort Tasks page
    Then Operator verify displayed nodes on Sort Tasks page:
      | {sort-task-hub}         |
      | {sort-task-next-hub}    |
      | {sort-task-middle-tier} |
      | {sort-task-zone}        |
      | {sort-task-zone}        |
    And Operator verify following nodes are highlighted on Sort Tasks page:
      | {sort-task-zone} |
      | {sort-task-zone} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op