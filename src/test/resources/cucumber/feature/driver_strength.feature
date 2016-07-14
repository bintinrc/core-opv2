@selenium
Feature: driver strength

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administrator

  Scenario: op filter driver strength by zones
    Given op click navigation driver strength
    When in driver strength driver strength is filtered by zone

  Scenario: op filter driver strength by driver-type
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength driver strength is filtered by driver-type

  # add new
  Scenario: op add new driver
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength add new driver button is clicked
    When in driver strength enter default value of new driver
    Then in driver strength new driver should get created

  Scenario: op search driver using searching box
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength searching driver
    Then in driver strength verifying driver

  Scenario: op change driver coming status
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength searching driver
    When in driver strength driver coming status is changed
#
  Scenario: op view contact aldira putra
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength searching driver
    When in driver strength clicking on view contact button

  # edit existing
  Scenario: op add new driver
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength searching new created driver
    When in driver strength edit new driver button is clicked

  # delete existing
  Scenario: op add new driver
    Given op click navigation dp administrator
    Given op click navigation driver strength
    When in driver strength searching new created driver
    When in driver strength delete new driver button is clicked
    Then in driver strength the created driver should not exist

  Scenario: op logout from operator portal
    Given op click navigation dp administrator
    When logout button is clicked
    Then op back in the login page
    Then close browser