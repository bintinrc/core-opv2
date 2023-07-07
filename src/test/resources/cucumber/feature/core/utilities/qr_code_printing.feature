@OperatorV2 @Core @Utilities @QrCodePrinting
Feature: QR Code Printing

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Create QR Code from Random Text and Verify the Created QR Code is Correct (uid:dac16149-15f8-4af1-9dce-cff848e1cf15)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator create QR Code from random text on QRCode Printing page
    Then Operator verify the created QR Code is correct
