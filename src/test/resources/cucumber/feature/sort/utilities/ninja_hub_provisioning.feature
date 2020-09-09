@Sort @Utilities @NinjaHubProvisioning @Saas
Feature: Ninja Hub Provisioning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Show Ninja Hub Provisioning QRCode (uid:947f5645-c8a3-444a-a288-4e83bbfffcd5)
    Given Operator go to menu Utilities -> Ninja Hub Provisioning
    When Operator download QR Code of Mobile Applications on Ninja Hub Provisioning page
    Then Operator verify the QR Code on Ninja Hub Provisioning page contains the same text as the link text printed below the QR Code

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
