@OperatorV2 @Core @SystemSettings @PrinterSettings
Feature: Printer Settings

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePrinter @MediumPriority
  Scenario: Operator Add Printer Setting
    Given Operator go to menu System Settings -> Printer Settings
    When Operator click Add Printer button
    Then Operator verify Add Printer form is displayed
    When Operator create Printer Settings with details:
      | name      | Printer {gradle-current-date-yyyyMMddHHmmsss} |
      | ipAddress | 127.0.0.1:9000                                |
      | version   | 3                                             |
      | isDefault | true                                          |
    Then Operator verify Printer Settings is added successfully

  @DeletePrinter @MediumPriority
  Scenario: Operator Delete Printer Setting
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator adds new printer using data below:
      | name      | Printer {gradle-current-date-yyyyMMddHHmmsss} |
      | ipAddress | 127.0.0.1:9000                                |
      | version   | 3                                             |
      | isDefault | true                                          |
    And Operator go to menu System Settings -> Printer Settings
    And Operator delete Printer Settings
    Then Operator verify Printer Settings is deleted successfully

  @DeletePrinter @MediumPriority
  Scenario Outline: Operator Edit Printer Setting - <Note>
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
      | Note            | printerSettingsName                                             | configName | configValue                                                        |
      | Edit Name       | Printer - Edit Name {gradle-current-date-yyyyMMddHHmmsss}       | name       | Printer - Edit Name {gradle-current-date-yyyyMMddHHmmsss} [EDITED] |
      | Edit IP Address | Printer - Edit IP Address {gradle-current-date-yyyyMMddHHmmsss} | ipAddress  | 192.168.0.1:9000                                                   |
      | Edit Version    | Printer - Edit Version {gradle-current-date-yyyyMMddHHmmsss}    | version    | 2                                                                  |

  @DeletePrinter @MediumPriority
  Scenario: Operator Set Printer as Default Printer
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator adds new printer using data below:
      | name      | Printer {gradle-current-date-yyyyMMddHHmmsss} |
      | ipAddress | 127.0.0.1:9000                                |
      | version   | 3                                             |
      | isDefault | false                                         |
    When Operator go to menu System Settings -> Printer Settings
    And Operator set printer as default printer
    Then Operator verifies that success toast displayed:
      | top | Set successfully |
    And Operator verify Printer Settings is set as default
