@OperatorV2 @OperatorV2Part1 @QrCodePrinting @Saas
Feature: QR Code Printing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create QR Code from random text and verify the created QR Code is correct (uid:32784ac6-04a4-4a28-9da7-aecda3f830e7)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator create QR Code from random text on QRCode Printing page
    Then Operator verify the created QR Code is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
