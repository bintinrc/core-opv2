@selenium @shipment @dev
Feature: shipment linehaul

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page
    Then op click navigation Linehaul Management in Inter-Hub

  # create linehaul
  Scenario: Create Linehaul
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
  Scenario: Edit Linehaul
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
  Scenario: Delete Linehaul
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