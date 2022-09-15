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
    And Operator select region on Sort Task page
      | regionName | {region-name} |
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
    And Operator select region on Sort Task page
      | regionName | {region-name} |
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
    And Operator select region on Sort Task page
      | regionName | {region-name} |
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
    And Operator refresh table on Sort Tasks page
    Then Operator verify removed outputs removed on tree list

  @CloseNewWindows
  Scenario: Search sort nodes on Sort Structure Page (uid:7266300d-faed-4254-9b5a-d68ec8e51991)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {sort-task-hub} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {sort-task-hub}      |
      | {sort-task-next-hub} |
    And Operator verifies graph contains following Middle Tier nodes:
      | {sort-task-middle-tier} |
    And Operator verifies graph contains following Zone nodes:
      | {sort-task-zone} |
    And Operator verifies graph contains following duplicated nodes:
      | label            | count |
      | {sort-task-zone} | 2     |
    When Operator search for "{sort-task-middle-tier}" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {sort-task-hub}         |
      | {sort-task-middle-tier} |
      | {sort-task-zone}        |

  @CloseNewWindows
  Scenario: Click on nodes (uid:ff4c25d4-25c0-466c-8bd0-ce5ceb0e0036)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {sort-task-hub} |
    And Operator click View Sort Structure on Sort Tasks page
    Then Operator verifies graph contains following Hub nodes:
      | {sort-task-hub}      |
      | {sort-task-next-hub} |
    And Operator verifies graph contains following Middle Tier nodes:
      | {sort-task-middle-tier} |
    And Operator verifies graph contains following Zone nodes:
      | {sort-task-zone} |
    And Operator verifies graph contains following duplicated nodes:
      | label            | count |
      | {sort-task-zone} | 2     |
    When Operator search for "{sort-task-middle-tier}" node on View Sort Structure page
    Then Operator verifies graph contains exactly following nodes:
      | {sort-task-hub}         |
      | {sort-task-middle-tier} |
      | {sort-task-zone}        |
    When Operator clicks on "{sort-task-middle-tier}" node
    Then Operator verifies graph contains exactly following nodes:
      | {sort-task-middle-tier} |
      | {sort-task-zone}        |


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
    And Operator refresh table on Sort Tasks page
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
    And Operator refresh table on Sort Tasks page
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
    And Operator refresh table on Sort Tasks page
    Then Operator verify removed outputs removed on tree list
    When Operator go to menu Sort -> Sort Tasks
    And Sort Belt Tasks page is loaded
    And Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator refresh table on Sort Tasks page
    And Operator open the sidebar menu on Sort Tasks page
    And Operator select region on Sort Task page
      | regionName | {region-name} |
    And Operator select a sort task
    Then Operator verifies that "{hub-name} modified" success notification is displayed
    When Operator select hub on Sort Tasks page:
      | hubName | {hub-name} |
    And Operator refresh table on Sort Tasks page
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