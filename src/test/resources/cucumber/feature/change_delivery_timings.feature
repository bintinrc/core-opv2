@OperatorV2 @ChangeDeliveryTimings @Current
Feature: Change Delivery Timings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator downloads the sample CSV file
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator click on Download Sample CSV File Button
    Then verify the csv file sample

  Scenario: Operator uploads the CSV file
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file
      | tracking_id        | start_date | end_date   | timewindow |
      | NVSGTSTESB14121702 | 2017-12-29 | 2017-12-30 | 0          |
    Then Operator verify that the Delivery Time Updated
    Given Operator go to menu Order -> All Orders
    When Operator entering the tracking ID
    Then Operator switch tab and verify the delivery time
#
#  Scenario: Operator uploads the CSV file with invalid Tracking ID
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file
#      | Tracking Id        | Start Date | End Date | Timewindow ID |
#      | SOMETHINGBORROW    | 12/28/17   | 12/29/17 | -1            |
#    Then Operator verify the tracking ID is invalid
#
#  Scenario: Operator uploads the CSV file with invalid order state
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file
#      | Tracking Id        | Start Date | End Date | Timewindow ID |
#      | NVSGTSTESBPJ121206 | 12/28/17   | 12/29/17 | 0             |
#    Then Operator verify the state order of the Tracking ID is invalid
#
#  Scenario: Operator uploads the CSV file with one of the date is empty
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file
#      | Tracking Id        | Start Date | End Date | Timewindow ID |
#      | NVSGTSTESBPJ121204 |            | 12/29/17 | -1            |
#    Then Operator verify the start and end date is not indicated correctly
#
#  Scenario: Operator uploads the CSV file with start date is later than end date
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file
#      | Tracking Id        | Start Date | End Date | Timewindow ID |
#      | NVSGTSTESBPJ121204 | 12/30/17   | 12/28/17 | -1            |
#    Then Operator verify that start date is later than end date
#
#  Scenario: Operator uploads the CSV file with both date empty
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Shipper Support -> Change Delivery Timings
#    When Operator uploads the CSV file
#      | Tracking Id        | Start Date | End Date | Timewindow ID |
#      | NVSGTSTESBPJ121206 |            |          | 0             |
#    Then Operator verify system using current date

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser