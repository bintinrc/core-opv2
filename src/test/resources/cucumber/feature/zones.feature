@Zones @selenium
Feature: Zones

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @Zones#01
  Scenario: Operator create, update and delete Zone
    Given Operator go to menu "Routing" -> "Zones"
    When Operator create new Zone using Hub "30JKB"

  @KillBrowser
  Scenario: Kill Browser
