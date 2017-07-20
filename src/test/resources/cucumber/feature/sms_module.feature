@Sample
Feature: Sample Feature

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator send sms
    Given op click navigation SMS Module in Mass Communications

  @KillBrowser
  Scenario: Kill Browser
