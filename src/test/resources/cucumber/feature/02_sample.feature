@02Sample @Dummy
Feature: Sample 02

  @LaunchBrowser @02Sample#01 @02Sample#02 @02Sample#03
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @02Sample#01
  Scenario: Scenario 1 on Sample 2 (uid:9e1d4874-d927-438a-abdf-8cde0308f35b)
    Given dummy "success"

  @02Sample#02
  Scenario: Scenario 2 on Sample 2 (uid:bd210076-fd96-4d1a-8277-ec119286680c)
    Given dummy "failed"

  @02Sample#03
  Scenario: Scenario 3 on Sample 2 (uid:830216ec-bc25-4921-8950-40e6bd8818af)
    Given dummy "success"

  @KillBrowser @02Sample#01 @02Sample#02 @02Sample#03
  Scenario: Kill Browser
