@selenium @shipment @dev
Feature: shipment linehaul

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  # create linehaul
  Scenario: Create Linehaul
    Given op click navigation Linehaul Management in Inter-Hub
    When create new linehaul:
      | name      | LINEHAUL AUTOMATION     |
      | comment   | yayayayayaya            |
      | hubs      | 30JKB,DOJO,EASTGW       |
      | frequency | Weekly                  |
      | days      | Monday,Friday           |
    Then linehaul exist

#  @closeBrowser
#  Scenario: close browser