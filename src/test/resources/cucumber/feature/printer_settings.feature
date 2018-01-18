@OperatorV2 @PrinterSettings
Feature: Shipment Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Add Printer Settings (uid:f139cffa-0c34-45c2-8d36-15c43e47063f)
    Given Operator go to menu System Settings -> Printer Settings
    When op click add Printer button
    Then Add Printer Form on display
    When op create printer setting with details:
    | name      | Automation Printer  |
    | ip        | 127.0.0.1:9000      |
    | version   | 3                   |
    | default   | true                |
    Then printer setting added
    When op delete printer settings
    Then printer setting deleted

  Scenario: Delete Printer Settings (uid:4228809e-130b-40d6-93ea-258a8182700a)
    Given Operator go to menu System Settings -> Printer Settings
    When op click add Printer button
    Then Add Printer Form on display
    When op create printer setting with details:
      | name      | Automation Printer Delete |
      | ip        | 127.0.0.1:9000            |
      | version   | 3                         |
      | default   | true                      |
    Then printer setting added
    When op delete printer settings
    Then printer setting deleted

  Scenario Outline: Edit Printer Setting (<hiptest-uid>)
    Given Operator go to menu System Settings -> Printer Settings
    When op click add Printer button
    Then Add Printer Form on display
    When op create printer setting with details:
      | name      | <settingName>       |
      | ip        | 127.0.0.1:9000      |
      | version   | 3                   |
      | default   | true                |
    Then printer setting added
    When op edit "<detailName>" with "<editValue>" in Printer Settings "<settingName>"
    Then printer setting edited
    When op delete printer settings
    Then printer setting deleted
  Examples:
    | Note            | hiptest-uid                              | settingName                    | detailName  | editValue                 |
    | Edit Name       | uid:57ce879c-d076-495f-b3f4-1d1ea0d0af8c | Automation Printer Name Edit   | name        | Automation Printer Edited |
    | Edit IP Address | uid:9cf3df1f-2182-4d55-a5ae-3691d972ded4 | Automation Printer Ip Edit     | ip          | 172.33.160.113:9000       |
    | Edit Version    | uid:70800e26-83ef-4342-a996-679f099d2a93 | Automation Printer Ver Edit    | version     | 4                         |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
