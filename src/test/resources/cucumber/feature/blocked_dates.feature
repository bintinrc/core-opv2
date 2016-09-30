@selenium @saas
Feature: blocked dates

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  # add blocked dates
  Scenario: add blocked date (uid:0877c2fd-f75e-4f90-96a8-8ce8da082009)
    Given op click navigation Blocked Dates in Shipper Support
    When blocked dates add
    Then blocked dates verify add

  # remove blocked dates
  Scenario: remove blocked date (uid:e3fe4f5f-204f-40fc-be9e-770784af328b)
    Given op click navigation Blocked Dates in Shipper Support
    When blocked dates remove
    Then blocked dates verify remove

  @closeBrowser
  Scenario: close browser