@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedulesID @CreateReportSchedulesID

Feature: Create Report Schedules - ID

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Frequency Monthly - “SHIPPER” Success Billing Report - All Shippers - Default Template - ID (uid:088f1972-52d1-41f4-9e86-389f2bc680b4)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Monthly                                                                            |
      | reportFor      | All Shippers                                                                       |
      | fileGroup      | SHIPPER                                                                            |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully

  Scenario: Create Report Schedule - Frequency Weekly - “SCRIPT” Success Billing Report -  Select By Multiple Script ID - Custom Template - ID (uid:8475a922-d9b2-4de2-a034-a41c31abee10)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Weekly                                                                             |
      | day            | Monday                                                                             |
      | reportFor      | Select By Script IDs                                                               |
      | scriptIds      | {pricing-script-id} - {pricing-script-name}                                        |
      | fileGroup      | SCRIPT                                                                             |
      | reportTemplate | {csv-template}                                                                     |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully