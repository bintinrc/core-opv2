@01Sample @Dummy
Feature: Sample 01

  @LaunchBrowser @01Sample#01 @01Sample#02 @01Sample#03
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @01Sample#01
  Scenario: Scenario 1 on Sample 1 (uid:b7a6c2b2-66c0-4e7d-890c-b0099cef4b5a)
    Given dummy "success"

  @01Sample#02
  Scenario: Scenario 2 on Sample 1 (uid:70921910-cb0a-4283-93ad-34431fd86b98)
    Given dummy "success"

  @01Sample#03
  Scenario: Scenario 3 on Sample 1 (uid:3f54984e-aaa1-494c-a27b-68af2d809071)
    Given dummy "failed"

  @KillBrowser @01Sample#01 @01Sample#02 @01Sample#03
  Scenario: Kill Browser
