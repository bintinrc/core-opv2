@selenium @shipment
Feature: shipment linehaul

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page
    Then op click navigation Linehaul Management in Inter-Hub

  Scenario: Create Linehaul (uid:3eeaa647-c1a2-40a1-8ee4-da898e7e2e7d)
    Given op click tab LINEHAUL ENTRIES
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO            |
      | comment   | created at          |
      | hubs      | 30JKB,DOJO,EASTGW   |
      | frequency | Weekly              |
      | days      | Monday,Friday       |
    Then linehaul exist
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linhaul filter

  Scenario: Edit Linehaul (uid:85dbd34f-25ea-4ada-accc-884a8098f8e2)
    Given op click tab LINEHAUL ENTRIES
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO            |
      | comment   | created at          |
      | hubs      | 30JKB,DOJO,EASTGW   |
      | frequency | Weekly              |
      | days      | Monday,Friday       |
    Then linehaul exist
    When op click edit action button
    When edit linehaul with:
      | name      | JKT-AUTO EDITED    |
      | comment   | created at         |
      | hubs      | 30JKB,EASTGW       |
      | frequency | Weekly             |
      | days      | Monday,Friday      |
    Then linehaul edited
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linhaul filter

  Scenario: Delete Linehaul (uid:89bc519c-6f5d-4f99-864a-2dbba4c52c22)
    Given op click tab LINEHAUL ENTRIES
    Given op click create linehaul button
    When create new linehaul:
      | name      | JKT-AUTO            |
      | comment   | created at          |
      | hubs      | 30JKB,DOJO,EASTGW   |
      | frequency | Weekly              |
      | days      | Monday,Friday       |
    Then linehaul exist
    When op click delete linehaul button
    Then linehaul deleted
    Then op click edit linhaul filter

#  Scenario: Check linehaul schedule (uid:8b178ed7-6da6-4207-8cb6-f75327533ba2)
#    Given op click tab LINEHAUL ENTRIES
#    Given op click create linehaul button
#    When create new linehaul:
#      | name      | JKT-AUTO            |
#      | comment   | created at          |
#      | hubs      | 30JKB,DOJO,EASTGW   |
#      | frequency | Weekly              |
#      | days      | Monday,Friday       |
#    Then linehaul exist
#    Then Schedule is right
#    Then op click tab LINEHAUL ENTRIES
#    Then op click Load All Selection
#    When op click delete linehaul button
#    Then linehaul deleted
#    Then op click edit linhaul filter
#
#  Scenario: Create linehaul on linehaul schedule page (uid:fe37a8e4-b435-45ef-8411-8bd0a37450d0)
#    Given op click tab LINEHAUL DATE
#    Given op click create linehaul button
#    When create new linehaul:
#      | name      | JKT-AUTO            |
#      | comment   | created at          |
#      | hubs      | 30JKB,DOJO,EASTGW   |
#      | frequency | Weekly              |
#      | days      | Monday,Friday       |
#    Given op click tab LINEHAUL ENTRIES
#    Then linehaul exist
#    Then Schedule is right
#    Then op click tab LINEHAUL ENTRIES
#    Then op click Load All Selection
#    When op click delete linehaul button
#    Then linehaul deleted
#    Then op click edit linhaul filter
#
#  Scenario: Edit Linehaul on linehaul schedule page (uid:e24343fb-3ca4-4109-8221-873e88744351)
#      Given op click tab LINEHAUL DATE
#      Given op click create linehaul button
#      When create new linehaul:
#        | name      | JKT-AUTO            |
#        | comment   | created at          |
#        | hubs      | 30JKB,DOJO,EASTGW   |
#        | frequency | Weekly              |
#        | days      | Monday,Friday       |
#      Given op click tab LINEHAUL ENTRIES
#      Then linehaul exist
#      Then Schedule is right
#      When op click edit linehaul button on schedule
#      When edit linehaul with:
#        | name      | JKT-AUTO EDITED    |
#        | comment   | created at         |
#        | hubs      | 30JKB,EASTGW       |
#        | frequency | Weekly             |
#        | days      | Monday,Friday      |
#      Then linehaul edited
#      When op click delete linehaul button
#      Then linehaul deleted
#    Then op click edit linhaul filter

  @closeBrowser
  Scenario: close browser