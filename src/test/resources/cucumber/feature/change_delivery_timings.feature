@OperatorV2 @ChangeDeliveryTimings @Current
Feature: Change Delivery Timings

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator download and verify CSV file of Change Delivery Timings' sample (uid:9e4e2241-3488-43ea-abd4-a22480d313dd)
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator click on Download Button for Sample CSV File of Change Delivery Timings' sample
    Then Operator verify CSV file of Change Delivery Timings' sample

  Scenario: Operator uploads the CSV file on Change Delivery Timings page (uid:4449fbd6-9fac-4d92-bbe6-41ebc2d38303)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date   | timewindow |
      | NVSGTSTESB14121702 | 2017-12-29 | 2017-12-30 | 0          |
    Then Operator verify that the Delivery Time Updated on Change Delivery Timings page
    Given Operator go to menu Order -> All Orders
    When Operator entering the tracking ID
    Then Operator switch tab and verify the delivery time

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with null timewindow id (uid:07e9af4f-3762-468f-8538-8418c6f2627a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date   | timewindow |
      | NVSGTSTESB14121701 | 2018-01-29 | 2018-01-30 ||
    Then Operator verify that the Delivery Time Updated on Change Delivery Timings page
    Given Operator go to menu Order -> All Orders
    When Operator entering the tracking ID
    Then Operator switch tab and verify the delivery time

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with invalid Tracking ID (uid:79b23384-11ae-4d03-9d5b-16f35c2e4096)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date   | timewindow |
      | SOMETHINGBORROW    | 2017-12-29 | 2017-12-30 | -1         |
    Then Operator verify the tracking ID is invalid on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with invalid order state (uid:fbbabed4-94df-4f0b-95b4-f668836ba0fe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date   | timewindow |
      | NVSGTSTESBPJ121206 | 2017-12-29 | 2017-12-30 | 0          |
    Then Operator verify the state order of the Tracking ID is invalid on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with one of the date is empty (uid:58bd63ca-d461-47a6-a377-11dac88bbb8f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date   | timewindow |
      | NVSGTSTESB14121702 || 2017-12-29 | -1         |
    Then Operator verify the start and end date is not indicated correctly on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with start date is later than end date (uid:5b96c619-4a16-4490-8a29-c3274315eb64)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date   | timewindow |
      | NVSGTSTESB14121702 | 2017-12-31 | 2017-12-30 | -1         |
    Then Operator verify that start date is later than end date on Change Delivery Timings page

  Scenario: Operator uploads the CSV file on Change Delivery Timings page with both date empty (uid:7966f797-eb34-4ffc-ad44-499159cec435)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Change Delivery Timings
    When Operator uploads the CSV file of Change Delivery Timings page
      | tracking_id        | start_date | end_date | timewindow |
      | NVSGTSTESB14121702 ||| 0          |
    Then Operator verify that the Delivery Time Updated on Change Delivery Timings page
    Given Operator go to menu Order -> All Orders
    When Operator entering the tracking ID
    Then Operator verify system using current date

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser