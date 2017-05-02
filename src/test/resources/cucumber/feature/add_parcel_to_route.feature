@AddParcelToRoute @selenium
Feature: Add Parcel To Route

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @KillBrowser
  Scenario: Kill Browser
