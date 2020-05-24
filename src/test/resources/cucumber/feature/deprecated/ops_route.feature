@OperatorV2Deprecated @OperatorV2Part1Deprecated @OpsRoute
Feature: Ops Route

  #DEPRECATED

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator edit ops route (uid:691f10d8-9501-40c0-b204-c44a34071011)
    Given Operator go to menu Recovery -> Ops Route
    When Operator clicks edit button on table at Ops Route menu
    Then Operator verifies the Route ID is changed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
