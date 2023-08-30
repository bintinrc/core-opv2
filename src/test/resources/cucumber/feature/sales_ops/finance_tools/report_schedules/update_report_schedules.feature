@OperatorV2 @ShipperSupport @OperatorV2Part1 @LaunchBrowser @SalesOps @ReportSchedules @UpdateReportSchedules

Feature: Update Report Schedules

  Background: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Update Report Schedule - Update Frequency From Monthly to Weekly (uid:2d920f67-a17a-41dd-99e0-1115dbc50c77)
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
      | frequency | Weekly |
      | day       | Monday |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update Frequency From Weekly to Monthly (uid:d84173c4-70b2-4cc9-a2ee-58e16a5516f8)
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
      | fileGroup      | ALL                                                                                |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | frequency | Monthly |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update From All Shippers to Select By Parent Shipper (uid:e5381fff-8d18-4b24-b79f-1693578f621f)
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
      | reportFor     | Select By Parent Shipper                                       |
      | parentShipper | {shipper-sop-mktpl-v4-legacy-id} - {shipper-sop-mktpl-v4-name} |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update From Select One Shipper to All Shippers (uid:69382676-0c7b-4094-9f35-1e74c2b684e4)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency       | Monthly                                                                            |
      | reportFor       | Select One Shipper                                                                 |
      | shipperLegacyId | {shipper-v4-legacy-id}                                                             |
      | shipperName     | {shipper-v4-name}                                                                  |
      | fileGroup       | ALL                                                                                |
      | reportTemplate  | {default-csv-template}                                                             |
      | emails          | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | reportFor | All Shippers |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update From Select One Shipper to Select By Script Ids (uid:1b387b72-b755-410b-9112-081bb8627fb3)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency       | Monthly                                                                            |
      | reportFor       | Select One Shipper                                                                 |
      | shipperLegacyId | {shipper-v4-legacy-id}                                                             |
      | shipperName     | {shipper-v4-name}                                                                  |
      | fileGroup       | ALL                                                                                |
      | reportTemplate  | {default-csv-template}                                                             |
      | emails          | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | reportFor | Select By Script IDs                                      |
      | scriptIds | {pricing-script-id-weight} - {pricing-script-name-weight} |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update Orders Aggregation (uid:10370ce9-d465-4fd8-ab76-4607b771c024)
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
      | fileGroup | AGGREGATED |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update Custom Template (uid:df839d7b-ab0f-4ecb-9653-bebd6596a048)
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
      | reportTemplate | {custom-csv-template} |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update Day of Week (uid:5bf18bc3-a8dc-4692-8894-54e75c0583fb)
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
      | fileGroup      | ALL                                                                                |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | frequency | Weekly  |
      | day       | Tuesday |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Schedule Report - Update Name and Description (uid:c252c1a6-7d1f-4a6d-914f-ee948fd948f8)
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
      | fileGroup      | ALL                                                                                |
      | reportTemplate | {default-csv-template}                                                             |
      | emails         | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | name        | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-Update-{{6-random-digits}}              |
      | description | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} -Update |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario: Update Report Schedule - Update Shipper (uid:6fa00d8c-77c5-4416-945b-0d0b09214879)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name            | Dummy-Report-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}}             |
      | description     | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency       | Weekly                                                                             |
      | day             | Monday                                                                             |
      | reportFor       | Select One Shipper                                                                 |
      | shipperLegacyId | {shipper-v4-legacy-id}                                                             |
      | shipperName     | {shipper-v4-name}                                                                  |
      | fileGroup       | ALL                                                                                |
      | reportTemplate  | {default-csv-template}                                                             |
      | emails          | {qa-email-address}                                                                 |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | reportFor       | Select One Shipper         |
      | shipperLegacyId | {shipper-sop-v4-legacy-id} |
      | shipperName     | {shipper-sop-v4-name}      |
    And Operator verify update report schedule success message
    And Operator verify report schedule is updated successfully

  Scenario Outline: Update Report Schedule - Update Name - Duplicate Found (uid:9b0863d2-fd84-45f4-88ad-b545ec0200cf)
    Given Operator go to menu Finance Tools -> Report Schedules
    When Report schedules page is loaded
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | <report_1_name>                                                |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Weekly                                                                             |
      | day            | Monday                                                         |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    And Operator clicks create new schedule button
    And Create report scheduling page is loaded
    Then Operator creates report scheduling with below data
      | name           | <report_2_name>                                                |
      | description    | Dummy-Report-Description-{gradle-current-date-yyyyMMddHHmmsss}-{{6-random-digits}} |
      | frequency      | Weekly                                                                             |
      | day            | Monday                                                         |
      | reportFor      | All Shippers                                                   |
      | fileGroup      | ALL                                                            |
      | reportTemplate | {default-csv-template}                                         |
      | emails         | {qa-email-address}                                             |
    And Operator verify create report schedule success message
    Then Operator search report schedule and got to edit page
    Then Operator updates report scheduling with below data
      | name | <report_1_name> |
    And Operator verifies that error toast is displayed on Report Schedules page as below:
      | top    | Network Request Error                       |
      | bottom | Report Schedule Name <report_1_name> exists |
    Examples:
      | report_1_name                                        | report_2_name                                        |
      | Dummy-Report-1-{gradle-current-date-yyyyMMddHHmmsss} | Dummy-Report-2-{gradle-current-date-yyyyMMddHHmmsss} |