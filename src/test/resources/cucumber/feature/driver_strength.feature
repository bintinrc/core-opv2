@selenium
Feature: driver strength

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administrator

  Scenario: op filter driver strength by zones
    Given op click navigation driver strength
    When driver strength is filtered by zone

  Scenario: op filter driver strength by driver-type
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When driver strength is filtered by driver-type

  Scenario: op search driver using searching box
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When searching driver antoni
    Then verifying driver antoni

  Scenario: op change driver coming status
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When driver coming status is changed

  Scenario: op view contact aldira putra
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When searching driver aldira putra
    When clicking on aldira putra view contact button

  # add new
  # edit existing
  # delete existing

  Scenario: op logout from operator portal
    Given op click navigation dp administrator
    When logout button is clicked
    Then op back in the login page
    Then close browser