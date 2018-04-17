@OperatorV2 @NinjaHubProvisioning
Feature: Ninja Hub Provisioning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator verify the QR Code on Ninja Hub Provisioning page contains the same text as the link text printed below the QR Code (uid:4252b89b-36a6-48c0-a665-9a916a4c056d)
    Given Operator go to menu Utilities -> Ninja Hub Provisioning
    When Operator download QR Code of Mobile Applications on Ninja Hub Provisioning page
    Then Operator verify the QR Code on Ninja Hub Provisioning page contains the same text as the link text printed below the QR Code

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
