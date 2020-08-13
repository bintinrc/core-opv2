@OperatorV2 @SystemSettings @OperatorV2Part1 @PrinterSettings @Saas
Feature: Printer Settings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePrinter
  Scenario: Add Printer Settings (uid:f139cffa-0c34-45c2-8d36-15c43e47063f)
    Given Operator go to menu System Settings -> Printer Settings
    When Operator click Add Printer button
    Then Operator verify Add Printer form is displayed
    When Operator create Printer Settings with details:
      | name      | Printer {gradle-current-date-yyyyMMddHHmmsss} |
      | ipAddress | 127.0.0.1:9000                                |
      | version   | 3                                             |
      | isDefault | true                                          |
    Then Operator verify Printer Settings is added successfully

  @DeletePrinter
  Scenario: Delete Printer Settings (uid:4228809e-130b-40d6-93ea-258a8182700a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator adds new printer using data below:
      | name      | Printer {gradle-current-date-yyyyMMddHHmmsss} |
      | ipAddress | 127.0.0.1:9000                                |
      | version   | 3                                             |
      | isDefault | true                                          |
    And Operator go to menu System Settings -> Printer Settings
    And Operator delete Printer Settings
    Then Operator verify Printer Settings is deleted successfully

  @DeletePrinter
  Scenario Outline: Edit Printer Setting (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator adds new printer using data below:
      | name      | <printerSettingsName> |
      | ipAddress | 127.0.0.1:9000        |
      | version   | 3                     |
      | isDefault | true                  |
    And Operator go to menu System Settings -> Printer Settings
    And Operator set "<configName>" = "<configValue>" for Printer Settings with name = "<printerSettingsName>"
    Then Operator verify Printer Settings is edited successfully
    Examples:
      | Note            | hiptest-uid                              | printerSettingsName                                             | configName | configValue                                                        |
      | Edit Name       | uid:57ce879c-d076-495f-b3f4-1d1ea0d0af8c | Printer - Edit Name {gradle-current-date-yyyyMMddHHmmsss}       | name       | Printer - Edit Name {gradle-current-date-yyyyMMddHHmmsss} [EDITED] |
      | Edit IP Address | uid:9cf3df1f-2182-4d55-a5ae-3691d972ded4 | Printer - Edit IP Address {gradle-current-date-yyyyMMddHHmmsss} | ipAddress  | 192.168.0.1:9000                                                   |
      | Edit Version    | uid:70800e26-83ef-4342-a996-679f099d2a93 | Printer - Edit Version {gradle-current-date-yyyyMMddHHmmsss}    | version    | 2                                                                  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op