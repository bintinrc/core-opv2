@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedulesMY @UpdateReportSchedulesMY

Feature: Update Report Schedules - MY

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Update Report Schedule - MY (uid:6056c138-abb7-460c-85fb-88d3ad1dab4d)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Monthly                                                                            |
      | reportFor      | All Shippers                                                                       |
      | fileGroup      | ALL                                                                                |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} -Update             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} -Update |
      | frequency       | Weekly                                                                                     |
      | day             | Monday                                                                                     |
      | reportFor       | Select One Shipper                                                                         |
      | shipperLegacyId | {shipper-sop-normal-noDiscount-country-default-3-legacy-id}                                |
      | shipperName     | {shipper-sop-normal-noDiscount-country-default-3-name}                                     |
      | fileGroup       | SHIPPER                                                                                    |
      | reportTemplate  | {csv-template}                                                                             |
      | emails          | {qa-email-address},dummy.email@ninjavan.co                                                 |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully