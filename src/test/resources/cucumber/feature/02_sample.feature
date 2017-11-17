@02Sample @Dummy
Feature: Sample 02

  @LaunchBrowser @02Sample#01 @02Sample#02 @02Sample#03
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @02Sample#01
  Scenario: Scenario 1 on Sample 2
    Given dummy step

  @02Sample#02
  Scenario: Scenario 2 on Sample 2
    Given dummy step

  @02Sample#03
  Scenario: Scenario 3 on Sample 2
    Given dummy step

  @KillBrowser @02Sample#01 @02Sample#02 @02Sample#03
  Scenario: Kill Browser
