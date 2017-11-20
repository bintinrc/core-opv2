@PrinterSettings @selenium
Feature: Shipment Scanning

  @LaunchBrowser @PrinterSettings#01
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @PrinterSettings#01
  Scenario: Add Printer Settings (uid:f139cffa-0c34-45c2-8d36-15c43e47063f)
    Given op click navigation Printer Settings in System Settings
    When op click add Printer button
    Then Add Printer Form on display
    When op create printer setting with details:
    | name      | Automation Printer  |
    | ip        | 127.0.0.1:9000      |
    | version   | 3                   |
    | default   | true                |
    Then printer setting added
    When op delete printer settings

  @KillBrowser @PrinterSettings#01
  Scenario: Kill Browser
