@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedulesVN @CreateReportSchedulesVN

Feature: Create Report Schedules - VN

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Frequency Weekly - “SCRIPT” Success Billing Report - All Shippers - Default Template - VN (uid:5826508d-d586-48a1-b534-2ff7ae45f240)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Weekly                                                                             |
      | day            | Monday                                                                             |
      | reportFor      | All Shippers                                                                       |
      | fileGroup      | SCRIPT                                                                             |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully
