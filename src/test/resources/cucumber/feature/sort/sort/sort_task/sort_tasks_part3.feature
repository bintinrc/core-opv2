@Sort @SortTaskPart3
Feature: Sort Task

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteNodes
  Scenario: Removing and adding a sort task (uid:f4b78675-b8b7-4e28-bbcd-45b38477f732)
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
    And Operator select region on Sort Task page
      | regionName | {region-name} |
    And Operator select a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    Then Operator verify added outputs appears on tree list
    When Operator open the sidebar menu on Sort Tasks page
    And Operator remove selection of a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    Then Operator verify removed outputs removed on tree list
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator select region on Sort Task page
      | regionName | {region-name} |
    And Operator select a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    Then Operator verify added outputs appears on tree list

  @CloseNewWindows
  Scenario: Add a sort task - RTS Zone (uid:094b5d46-1a8c-4658-868c-20ebb695a14d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-6} |
      | hubId   | {hub-id-6}   |
    And Operator open the sidebar menu on Sort Tasks page
    And Operator select region on Sort Task page
      | regionName | {region-name-6} |
    And Operator select a RTS zone
      | rtsZone | RTS-SORT-SG-3-HUB |
    Then Operator verifies that "{hub-name-6} modified" success notification is displayed
    Then Operator verify RTS zone appears on tree list
      | rtsZone | RTS-SORT-SG-3-HUB |
    When Operator open the sidebar menu on Sort Tasks page
    And Operator remove selection of RTS zone
      | rtsZone | RTS-SORT-SG-3-HUB |
    Then Operator verifies that "{hub-name-6} modified" success notification is displayed

  @CloseNewWindows
  Scenario: Load Sort Entity List - No Children (uid:814f21d2-73bf-4705-896d-f9fd7e795d67)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-6} |
      | hubId   | {hub-id-6}   |
    Then Operator verify output on tree list
      | noOutput |

  @CloseNewWindows
  Scenario: Load Sort Entity List - Has Children (uid:928312c2-6375-48dc-8108-cd91dc70735b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {sort-task-hub}    |
      | hubId   | {sort-task-hub-id} |
    Then Operator verify displayed nodes on Sort Tasks page:
      | {sort-task-hub}         |
      | {sort-task-next-hub}    |
      | {sort-task-middle-tier} |
      | {sort-task-zone}        |

  @CloseNewWindows
  Scenario: Search sort nodes on Sort Structure Page - RTS zone (uid:4776cda5-157a-4345-b7d6-b9c3cc776691)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name-7} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {hub-name-7}         |
      | {sort-task-next-hub} |
    And Operator verifies graph contains following Middle Tier nodes:
      | {sort-task-middle-tier} |
    And Operator verifies graph contains following Zone nodes:
      | {sort-task-zone}     |
      | {rts-sort-task-zone} |
    And Operator verifies graph contains following duplicated nodes:
      | label            | count |
      | {sort-task-zone} | 2     |
    When Operator search for "{rts-sort-task-zone}" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {hub-name-7}         |
      | {rts-sort-task-zone} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op