@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedulesID @UpdateReportSchedulesID

Feature: Update Report Schedules - ID

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Update Report Schedule - ID (uid:e6daeb88-00c5-4929-814d-8d780a1fa5b6)
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
      | name           | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-Update-{{6-random-digits}}                                                                  |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} -Update                                                     |
      | frequency      | Weekly                                                                                                                                         |
      | day            | Monday                                                                                                                                         |
      | reportFor      | Select By Parent Shipper                                                                                                                       |
      | parentShipper  | {shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-legacy-id} - {shipper-sop-mktpl-v4-dummy-pricing-profile-delivery-discount-name} |
      | fileGroup      | SHIPPER                                                                                                                                        |
      | reportTemplate | {csv-template}                                                                                                                                 |
      | emails         | {qa-email-address},dummy.email@ninjavan.co                                                                                                     |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully