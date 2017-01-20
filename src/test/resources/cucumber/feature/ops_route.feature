@OpsRoute @selenium
Feature: Ops Route

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator edit ops route (uid:691f10d8-9501-40c0-b204-c44a34071011)
    Given op click navigation Ops Route in Recovery
    When op click edit button on table at Ops Route menu
    Then ops route id must be changed

  @KillBrowser
  Scenario: Kill Browser
