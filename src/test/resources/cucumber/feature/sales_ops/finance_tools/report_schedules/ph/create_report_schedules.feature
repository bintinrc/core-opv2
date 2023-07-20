@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedules @CreateReportSchedulesPH

Feature: Create Report Schedules - PH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Frequency Weekly - “SCRIPT” Success Billing Report - Select By Parent Shipper  - Custom Template - PH (uid:3086495a-8a31-4d8a-b1b5-7b07efed5453)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}                                     |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}                         |
      | frequency      | Weekly                                                                                 |
      | day            | Monday                                                                                 |
      | reportFor      | Select By Parent Shipper                                                               |
      | parentShipper  | {marketplace-loyalty-postpaid-legacy-id} - {marketplace-loyalty-postpaid-account-name} |
      | fileGroup      | SCRIPT                                                                                 |
      | reportTemplate | {default-csv-template}                                                                 |
      | emails         | {qa-email-address}                                                                     |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully
