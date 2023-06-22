@OperatorV2 @Core @SystemSettings @PrinterSettings
Feature: Printer Settings

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeletePrinter
  Scenario: Operator Add Printer Setting (uid:63ecfb9e-7bc1-4553-b277-ab08a7742f1d)
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
  Scenario: Operator Delete Printer Setting (uid:6f2634f3-d864-45b6-8e6a-5e0eed33c383)
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
  Scenario Outline: Operator Edit Printer Setting - <Note> (<hiptest-uid>)
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
      | Edit Name       | uid:b86927a3-04a0-495f-a6f8-7fad876f8279 | Printer - Edit Name {gradle-current-date-yyyyMMddHHmmsss}       | name       | Printer - Edit Name {gradle-current-date-yyyyMMddHHmmsss} [EDITED] |
      | Edit IP Address | uid:be805b7b-f524-4bef-8356-b07cc3d9f30f | Printer - Edit IP Address {gradle-current-date-yyyyMMddHHmmsss} | ipAddress  | 192.168.0.1:9000                                                   |
      | Edit Version    | uid:2d8c86e8-2843-432e-9f82-6b25eb02b16a | Printer - Edit Version {gradle-current-date-yyyyMMddHHmmsss}    | version    | 2                                                                  |

  @DeletePrinter
  Scenario: Operator Set Printer as Default Printer (uid:d9508f36-1deb-429d-8e43-c21aaddfba22)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator adds new printer using data below:
      | name      | Printer {gradle-current-date-yyyyMMddHHmmsss} |
      | ipAddress | 127.0.0.1:9000                                |
      | version   | 3                                             |
      | isDefault | false                                         |
    When Operator go to menu System Settings -> Printer Settings
    And Operator set printer as default printer
    Then Operator verifies that success toast displayed:
      | top                | Set successfully |
      | waitUntilInvisible | true             |
    And Operator verify Printer Settings is set as default
