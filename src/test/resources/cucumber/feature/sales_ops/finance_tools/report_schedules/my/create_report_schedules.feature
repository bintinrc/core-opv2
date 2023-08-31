@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedulesMY @CreateReportSchedulesMY

Feature: Create Report Schedules - MY

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Frequency Monthly - “SCRIPT” Success Billing Report - All Shippers - Default Template - MY (uid:378e4c71-2cde-4f15-8a9e-6bee182bfe34)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Monthly                                                                            |
      | reportFor      | All Shippers                                                                       |
      | fileGroup      | SCRIPT                                                                             |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully
