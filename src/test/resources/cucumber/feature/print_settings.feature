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
    When op delete printer settings "Automation Printer"
    Then printer setting deleted

  Scenario Outline: Edit Printer Setting (<hiptest-uid>)
    Given op click navigation Printer Settings in System Settings
    When op click add Printer button
    Then Add Printer Form on display
    When op create printer setting with details:
      | name      | Automation Printer  |
      | ip        | 127.0.0.1:9000      |
      | version   | 3                   |
      | default   | true                |
    Then printer setting added
    When op edit "<detailName>" with "<editValue>" in Printer Settings "Automation Printer"
    Then printer setting "<detailName>" edited
    When op delete printer settings "<settingName>"
    Then printer setting deleted
  Examples:
    | Note            | hiptest-uid                              | settingName                 | detailName  | editValue                 |
    | Edit Name       | uid:57ce879c-d076-495f-b3f4-1d1ea0d0af8c | Automation Printer Edited   | name        | Automation Printer Edited |
    | Edit IP Address | uid:9cf3df1f-2182-4d55-a5ae-3691d972ded4 | Automation Printer          | ip          | 172.33.160.113:9000       |
    | Edit Version    | uid:70800e26-83ef-4342-a996-679f099d2a93 | Automation Printer          | version     | 4                         |


  Scenario: Delete Printer Settings (uid:4228809e-130b-40d6-93ea-258a8182700a)
    Given op click navigation Printer Settings in System Settings
    When op click add Printer button
    Then Add Printer Form on display
    When op create printer setting with details:
      | name      | Automation Printer  |
      | ip        | 127.0.0.1:9000      |
      | version   | 3                   |
      | default   | true                |
    Then printer setting added
    When op delete printer settings "Automation Printer"
    Then printer setting deleted


  @KillBrowser @PrinterSettings#01
  Scenario: Kill Browser
