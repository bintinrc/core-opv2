@01Sample @Dummy
Feature: Sample 01

  @LaunchBrowser @01Sample#01 @01Sample#02 @01Sample#03
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @01Sample#01
  Scenario: Scenario 1 on Sample 1
    Given dummy step

  @01Sample#02
  Scenario: Scenario 2 on Sample 1
    Given dummy step

  @01Sample#03
  Scenario: Scenario 3 on Sample 1
    Given dummy step

  @KillBrowser @01Sample#01 @01Sample#02 @01Sample#03
  Scenario: Kill Browser
