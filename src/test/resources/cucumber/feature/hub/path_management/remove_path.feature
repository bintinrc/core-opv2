@OperatorV2 @MiddleMile @Hub @PathManagement @RemovePath
Feature: Remove Path

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Remove Path by Path Details (uid:a0c3b3d2-a3cb-4b67-bec1-41728631b2b6)
    Given no-op

  Scenario: Remove Path by Path Table (uid:17ea0b88-c3c4-43b2-86d7-0d59c9f73402)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op