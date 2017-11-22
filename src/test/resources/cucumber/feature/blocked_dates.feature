@BlockedDates @selenium @saas @BlockedDates#01
Feature: Blocked Dates

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  # add blocked dates
  Scenario: add blocked date (uid:0877c2fd-f75e-4f90-96a8-8ce8da082009)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When blocked dates add
    Then blocked dates verify add

  # remove blocked dates
  Scenario: remove blocked date (uid:e3fe4f5f-204f-40fc-be9e-770784af328b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When blocked dates remove
    Then blocked dates verify remove

  @KillBrowser
  Scenario: Kill Browser
