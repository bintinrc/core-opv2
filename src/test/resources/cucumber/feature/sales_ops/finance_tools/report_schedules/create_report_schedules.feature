@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedules @CreateReportSchedules

Feature: Create Report Schedules

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Invalid Email Address
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | abc@gmail.com                                                  |
    And Operator verifies that error toast is displayed on Report Schedules page as below:
      | errorMessage | Please enter only ninjavan.co email(s). |

  Scenario: Create New Schedule Report - Duplicate Schedule Name
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | {KEY_REPORT_SCHEDULE_TEMPLATE.name}                            |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verifies that error toast is displayed on Report Schedules page as below:
      | top    | Network Request Error                                           |
      | bottom | Report Schedule Name {KEY_REPORT_SCHEDULE_TEMPLATE.name} exists |

  Scenario: Create Report Schedule - Frequency Monthly - “ALL” Success Billing Report - All Shippers - Default Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully


  Scenario: Create Report Schedule - Frequency Weekly - “ALL” Success Billing Report - Select One Shipper - Custom Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency       | Weekly                                                         |
      | day             | Monday                                                         |
      | reportFor       | Select One Shipper                                             |
      | shipperLegacyId | {shipper-v4-legacy-id}                                         |
      | shipperName     | {shipper-v4-name}                                              |
      | fileGroup       | ALL                                                            |
      | reportTemplate  | {custom-csv-template}                                          |
      | emails          | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Monthly - “ALL” Success Billing Report - Select By Script ID - Default Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | Select By Script IDs                                           |
      | scriptIds      | {pricing-script-id-weight} - {pricing-script-name-weight}      |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Weekly - “ALL” Success Billing Report - Select By Multiple Script ID - Custom Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}                                                    |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}                                        |
      | frequency      | Weekly                                                                                                |
      | day            | Monday                                                                                                |
      | reportFor      | Select By Script IDs                                                                                  |
      | scriptIds      | {pricing-script-id-weight} - {pricing-script-name-weight},{pricing-script-id} - {pricing-script-name} |
      | fileGroup      | ALL                                                                                                   |
      | reportTemplate | {custom-csv-template}                                                                                 |
      | emails         | {qa-email-address}                                                                                    |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Monthly - “SHIPPER” Success Billing Report -  Select By Parent Shipper  - Custom Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | Select By Parent Shipper                                       |
      | parentShipper  | {shipper-sop-mktpl-v4-legacy-id} - {shipper-sop-mktpl-v4-name} |
      | fileGroup      | SHIPPER                                                        |
      | reportTemplate | {custom-csv-template}                                          |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Monthly - “SHIPPER” Success Billing Report - Select One Shipper - Default Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency       | Monthly                                                        |
      | reportFor       | Select One Shipper                                             |
      | shipperLegacyId | {shipper-v4-legacy-id}                                         |
      | shipperName     | {shipper-v4-name}                                              |
      | fileGroup       | SHIPPER                                                        |
      | reportTemplate  | {default-csv-template}                                         |
      | emails          | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Weekly - “SHIPPER” Success Billing Report - All Shippers - Default Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Weekly                                                         |
      | day            | Monday                                                         |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | SHIPPER                                                        |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Monthly - “SCRIPT” Success Billing Report - All Shippers - Default Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Monthly                                                        |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | SCRIPT                                                         |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Monthly - “SCRIPT” Success Billing Report - Select One Shipper - Default Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency       | Monthly                                                        |
      | reportFor       | Select One Shipper                                             |
      | shipperLegacyId | {shipper-v4-legacy-id}                                         |
      | shipperName     | {shipper-v4-name}                                              |
      | fileGroup       | SCRIPT                                                         |
      | reportTemplate  | {default-csv-template}                                         |
      | emails          | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Weekly - “SCRIPT” Success Billing Report - Select By Parent Shipper  - Custom Template
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency      | Weekly                                                         |
      | day            | Monday                                                         |
      | reportFor      | Select By Parent Shipper                                       |
      | parentShipper  | {shipper-sop-mktpl-v4-legacy-id} - {shipper-sop-mktpl-v4-name} |
      | fileGroup      | SCRIPT                                                         |
      | reportTemplate | {custom-csv-template}                                          |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Monthly - “AGGREGATED” Success Billing Report - All Shippers
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name        | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency   | Monthly                                                        |
      | reportFor   | All Shippers                                                   |
      | fileGroup   | AGGREGATED                                                     |
      | emails      | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Weekly - “AGGREGATED” Success Billing Report - Select By Parent Shipper
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name          | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description   | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency     | Weekly                                                         |
      | day           | Monday                                                         |
      | reportFor     | Select By Parent Shipper                                       |
      | parentShipper | {shipper-sop-mktpl-v4-legacy-id} - {shipper-sop-mktpl-v4-name} |
      | fileGroup     | AGGREGATED                                                     |
      | emails        | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Weekly - “AGGREGATED” Success Billing Report - Select One Shipper
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency       | Weekly                                                         |
      | day             | Monday                                                         |
      | reportFor       | Select One Shipper                                             |
      | shipperLegacyId | {shipper-v4-legacy-id}                                         |
      | shipperName     | {shipper-v4-name}                                              |
      | fileGroup       | AGGREGATED                                                     |
      | emails          | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario:Create Report Schedule - Frequency Weekly - “AGGREGATED” Success Billing Report - Select By Script ID
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name        | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}             |
      | description | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss} |
      | frequency   | Weekly                                                         |
      | day         | Monday                                                         |
      | reportFor   | Select By Script IDs                                           |
      | scriptIds   | {pricing-script-id-weight} - {pricing-script-name-weight}      |
      | fileGroup   | AGGREGATED                                                     |
      | emails      | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully


