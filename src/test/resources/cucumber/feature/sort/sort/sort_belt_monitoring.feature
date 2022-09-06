@Sort @SortBeltMonitoring
Feature: Sort Belt Monitoring

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Check all data displays when no filter
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    Then Operator verifies sessions displayed in session list

  Scenario: Check user should be able to filter the list by HUB ID/Name
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "hub" with "{sbm-hub-id}"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "{sbm-hub-id}"
    When Operator searches "hub" with "invalid-id"
    Then Operator verifies there is no results displayed in session list
    When Operator searches "hub" with "{sbm-hub}"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "{sbm-hub}"
    When Operator searches "hub" with "invalid-name"
    Then Operator verifies there is no results displayed in session list

  Scenario: Check user should be able to filter the list by DEVICE ID/Name
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "device" with "{sbm-device-id}"
    Then Operator verifies sort belt monitoring result has "device" matched search term "{sbm-device-id}"
    When Operator searches "device" with "invalid-id"
    Then Operator verifies there is no results displayed in session list
    When Operator searches "device" with "{sbm-device}"
    Then Operator verifies sort belt monitoring result has "device" matched search term "{sbm-device}"
    When Operator searches "device" with "invalid-name"
    Then Operator verifies there is no results displayed in session list

  Scenario: Check displays correct result when filtering Start Date and End Date
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects "start time" as "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    And Operator selects "end time" as "{gradle-next-1-date-dd/MM/yyyy-HH:mm}"
    Then Operator verifies Start time after "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    And Operator verifies Completed time before "{gradle-next-1-date-dd/MM/yyyy-HH:mm}"

  Scenario: Check displays correct result when filtering HubID and Device ID and Start time
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "hub" with "{sbm-hub-id}"
    And Operator searches "device" with "{sbm-device}"
    And Operator selects "start time" as "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "{sbm-hub-id}"
    And Operator verifies sort belt monitoring result has "device" matched search term "{sbm-device}"
    And Operator verifies Start time after "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"

  Scenario:  Check user able to filter the list by a list of specific Tracking IDs
    Given API Operator creates new parcel download sessions with device id "{sbm-device-id}"
    And Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects created session
    And Operator searches with created TID
    Then Operator verifies sort belt monitoring result has tracking id displayed
    When Operator clears all search fields
    And Operator searches "tracking id" with "d4bd3a08"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check user is able to filter the list by a list of specific arm IDs
    Given API Operator creates new parcel download sessions with device id "{sbm-device-id}"
    And Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects created session
    And Operator searches with created ArmID
    Then Operator verifies sort belt monitoring result has expected arm id displayed
    When Operator searches "arm id" with "999"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check user should be search multiple TIDs
    Given API Operator creates new parcel download sessions with device id "{sbm-device-id}"
    And Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects created session
    And Operator searches with "2" created TIDs
    Then Operator verifies sort belt monitoring result has tracking ids displayed correctly

  Scenario: Check user is not able to search multiple value on Arm ID field
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects first session
    And Operator searches "arm id" with "1, 3"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check correct data return when searching combine TID and Arm ID
    Given API Operator creates new parcel download sessions with device id "{sbm-device-id}"
    And Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects created session
    And Operator searches with created TID
    And Operator searches with created ArmID
    Then Operator verifies sort belt monitoring result has tracking id displayed
    And Operator verifies sort belt monitoring result has expected arm id displayed

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op