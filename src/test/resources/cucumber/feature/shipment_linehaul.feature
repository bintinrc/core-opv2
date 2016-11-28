@selenium @shipment @dev
Feature: shipment linehaul

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page
    Then op click navigation Linehaul Management in Inter-Hub

  # create linehaul
  Scenario: Create Linehaul (uid:3eeaa647-c1a2-40a1-8ee4-da898e7e2e7d)
    Given op click create linehaul button
    When create new linehaul:
      | name      | LINEHAUL AUTOMATION     |
      | comment   | created at              |
      | hubs      | 30JKB,DOJO,EASTGW       |
      | frequency | Weekly                  |
      | days      | Monday,Friday           |
    Then linehaul exist
    When op click edit action button
    When op click delete linehaul button
    Then linehaul deleted

  # edit linehaul
  Scenario: Edit Linehaul (uid:85dbd34f-25ea-4ada-accc-884a8098f8e2)
    Given op click tab LINEHAUL ENTRIES
    Given op click create linehaul button
    When create new linehaul:
      | name      | LINEHAUL AUTOMATION     |
      | comment   | created at              |
      | hubs      | 30JKB,DOJO,EASTGW       |
      | frequency | Weekly                  |
      | days      | Monday,Friday           |
    Then linehaul exist
    When op click edit action button
    When edit linehaul with:
      | name      | LINEHAUL AUTOMATION EDITED    |
      | comment   | created at                    |
      | hubs      | 30JKB,EASTGW                  |
      | frequency | Weekly                        |
      | days      | Monday,Friday                 |
    Then linehaul edited
    When op click edit action button
    When op click delete linehaul button
    Then linehaul deleted

  # delete linehaul
  Scenario: Delete Linehaul (uid:89bc519c-6f5d-4f99-864a-2dbba4c52c22)
    Given op click tab LINEHAUL ENTRIES
    Given op click create linehaul button
    When create new linehaul:
      | name      | LINEHAUL AUTOMATION     |
      | comment   | created at              |
      | hubs      | 30JKB,DOJO,EASTGW       |
      | frequency | Weekly                  |
      | days      | Monday,Friday           |
    Then linehaul exist
    When op click edit action button
    When op click delete linehaul button
    Then linehaul deleted

  @closeBrowser
  Scenario: close browser