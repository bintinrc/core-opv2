@OperatorV2Deprecated @OperatorV2Part2Deprecated
Feature: Shipment Linehaul

   # THIS FEATURE HAS BEEN DEPRECATED

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Linehaul (uid:3eeaa647-c1a2-40a1-8ee4-da898e7e2e7d)
    Given Operator go to menu Inter-Hub -> Linehaul Management
    Given op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO                   |
      | comment   | Created at                 |
      | hubs      | {hub-name},{hub-name-2},GW |
      | frequency | Weekly                     |
      | days      | Monday,Friday              |
    Then linehaul exist
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linehaul filter

  Scenario: Edit Linehaul (uid:85dbd34f-25ea-4ada-accc-884a8098f8e2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Linehaul Management
    Given op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO                   |
      | comment   | Created at                 |
      | hubs      | {hub-name},{hub-name-2},GW |
      | frequency | Weekly                     |
      | days      | Monday,Friday              |
    Then linehaul exist
    When op click edit action button
    When edit linehaul with:
      | name      | JKT-AUTO EDITED         |
      | comment   | Created at              |
      | hubs      | {hub-name},{hub-name-2} |
      | frequency | Weekly                  |
      | days      | Monday                  |
    Then linehaul edited
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linehaul filter

  Scenario: Delete Linehaul (uid:89bc519c-6f5d-4f99-864a-2dbba4c52c22)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Linehaul Management
    Given op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO                   |
      | comment   | Created at                 |
      | hubs      | {hub-name},{hub-name-2},GW |
      | frequency | Weekly                     |
      | days      | Monday,Friday              |
    Then linehaul exist
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linehaul filter

  Scenario: Check linehaul schedule (uid:8b178ed7-6da6-4207-8cb6-f75327533ba2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Linehaul Management
    Given op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO                   |
      | comment   | Created at                 |
      | hubs      | {hub-name},{hub-name-2},GW |
      | frequency | Weekly                     |
      | days      | Monday,Friday              |
    Then linehaul exist
    Then Schedule is right
    Then op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    When Operator click "Load All Selection" on Linehaul Management page
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linehaul filter

  Scenario: Create linehaul on linehaul schedule page (uid:fe37a8e4-b435-45ef-8411-8bd0a37450d0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Linehaul Management
    Given op click tab LINEHAUL DATE
    Then op wait until 'Linehaul Date' tab on 'Linehaul Management' page is loaded
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO                   |
      | comment   | Created at                 |
      | hubs      | {hub-name},{hub-name-2},GW |
      | frequency | Weekly                     |
      | days      | Monday,Friday              |
    Given op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    Then linehaul exist
    Then Schedule is right
    Then op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    When Operator click "Load All Selection" on Linehaul Management page
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linehaul filter

  Scenario: Edit Linehaul on linehaul schedule page (uid:e24343fb-3ca4-4109-8221-873e88744351)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Linehaul Management
    Given op click tab LINEHAUL DATE
    Then op wait until 'Linehaul Date' tab on 'Linehaul Management' page is loaded
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO                   |
      | comment   | Created at                 |
      | hubs      | {hub-name},{hub-name-2},GW |
      | frequency | Weekly                     |
      | days      | Monday,Friday              |
    Given op click tab LINEHAUL ENTRIES
    Then op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded
    Then linehaul exist
    Then Schedule is right
    When op click edit linehaul button on schedule
    When edit linehaul with:
      | name      | JKT-AUTO EDITED         |
      | comment   | Created at              |
      | hubs      | {hub-name},{hub-name-2} |
      | frequency | Weekly                  |
      | days      | Monday                  |
    Then linehaul edited
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linehaul filter

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op