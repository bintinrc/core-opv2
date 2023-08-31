@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedulesTH @CreateReportSchedulesTH

Feature: Create Report Schedules - TH

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create Report Schedule - Frequency Weekly - “SHIPPER” Success Billing Report - All Shippers - Default Template - TH (uid:9510a5d0-5769-43b2-98d5-0fea238f7f7d)
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
      | fileGroup      | SHIPPER                                                                            |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    And Operator verify report schedule is created successfully
