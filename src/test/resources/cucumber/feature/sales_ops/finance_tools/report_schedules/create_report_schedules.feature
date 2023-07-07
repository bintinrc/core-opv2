@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedules @CreateReportSchedules

Feature: Create Report Schedules

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Invalid Email Address (uid:d7d4c86b-187f-4e9e-bb85-807038d902d9)
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

  Scenario: Create New Schedule Report - Duplicate Schedule Name (uid:3b3950ea-70e3-456b-aecd-d9804fc04b1c)
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

  Scenario: Create Report Schedule - Frequency Monthly - “ALL” Success Billing Report - All Shippers - Default Template (uid:ceb85534-e8f4-46cb-8466-d2fdb4b6f604)
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

  Scenario: Create Report Schedule - Frequency Weekly - “ALL” Success Billing Report - Select One Shipper - Custom Template (uid:03ed0535-4c1d-4197-bbdb-06d193bec83d)
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

  Scenario: Create Report Schedule - Frequency Monthly - “ALL” Success Billing Report - Select By Script ID - Default Template (uid:5af16ea1-33d2-41af-bb08-04c6761bdc4e)
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

  Scenario: Create Report Schedule - Frequency Weekly - “ALL” Success Billing Report - Select By Multiple Script ID - Custom Template (uid:c2e426c4-67a4-4e71-8459-ae805b42af82)
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

  Scenario: Create Report Schedule - Frequency Monthly - “SHIPPER” Success Billing Report -  Select By Parent Shipper  - Custom Template (uid:db554386-22aa-46cc-b33b-bc146adef301)
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

  Scenario: Create Report Schedule - Frequency Monthly - “SHIPPER” Success Billing Report - Select One Shipper - Default Template (uid:2b8d3016-35f6-4f0e-a5a5-7bb867285815)
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

  Scenario: Create Report Schedule - Frequency Weekly - “SHIPPER” Success Billing Report - All Shippers - Default Template (uid:add22eef-71bd-45d4-acd2-0f2b6941a83b)
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

  Scenario: Create Report Schedule - Frequency Monthly - “SCRIPT” Success Billing Report - All Shippers - Default Template (uid:a01fe4bd-eda6-4635-98f5-c89acf105e7a)
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

  Scenario: Create Report Schedule - Frequency Monthly - “SCRIPT” Success Billing Report - Select One Shipper - Default Template (uid:d8e66b41-3d6a-4c60-87f5-867f85c15c53)
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

  Scenario: Create Report Schedule - Frequency Weekly - “SCRIPT” Success Billing Report - Select By Parent Shipper  - Custom Template (uid:89e6a253-662c-4ec4-bbc2-fb69211239ee)
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

  Scenario: Create Report Schedule - Frequency Monthly - “AGGREGATED” Success Billing Report - All Shippers (uid:a3f69f21-6d0e-4bd5-894b-59660a402376)
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

  Scenario: Create Report Schedule - Frequency Weekly - “AGGREGATED” Success Billing Report - Select By Parent Shipper (uid:cf7e67b7-ccfe-45f9-be8e-d880b6ce84da)
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

  Scenario: Create Report Schedule - Frequency Weekly - “AGGREGATED” Success Billing Report - Select One Shipper (uid:c53a2249-12a2-4a3e-97da-2c1f0961941a)
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

  Scenario: Create Report Schedule - Frequency Weekly - “AGGREGATED” Success Billing Report - Select By Script ID (uid:5be7ff67-948c-4297-aad6-820310848130)
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