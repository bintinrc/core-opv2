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
    When Operator searches "hub" with "45"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "45"
    When Operator searches "hub" with "id"
    Then Operator verifies there is no results displayed in session list
    When Operator searches "hub" with "hubqc"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "hubqc"
    When Operator searches "hub" with "invalid name"
    Then Operator verifies there is no results displayed in session list

  Scenario: Check user should be able to filter the list by DEVICE ID/Name
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "device" with "1"
    Then Operator verifies sort belt monitoring result has "device" matched search term "1"
    When Operator searches "device" with "invalid id"
    Then Operator verifies there is no results displayed in session list
    When Operator searches "device" with "automation device"
    Then Operator verifies sort belt monitoring result has "device" matched search term "automation device"
    When Operator searches "device" with "invalid name"
    Then Operator verifies there is no results displayed in session list

  Scenario: Check displays correct result when filtering Start Date and End Date
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects "start time" as "20/06/2022 20:45"
    And Operator selects "end time" as "13/07/2022 23:00"
    Then Operator verifies Start time after "20/06/2022 20:45"
    And Operator verifies Completed time before "13/07/2022 23:00"

  Scenario: Check displays correct result when filtering HubID and Device ID and Start time and end time
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "hub" with "2"
    And Operator searches "device" with "automation device"
    And Operator selects "start time" as "01/07/2022 20:45"
    And Operator selects "end time" as "23/07/2022 23:00"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "2"
    And Operator verifies sort belt monitoring result has "device" matched search term "automation device"
    And Operator verifies Start time after "01/07/2022 20:45"
    And Operator verifies Completed time before "23/07/2022 23:00"

  Scenario:  Check user able to filter the list by a list of specific Tracking IDs
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "autoqcitem22"
    And Operator searches "tracking id" with "d4bd3a08-2852-4d13-b230-74bc185b6232"
    Then Operator verifies sort belt monitoring result has tracking ids displayed as below:
      | d4bd3a08-2852-4d13-b230-74bc185b6232 |
    When Operator clears all search fields
    And Operator searches "tracking id" with "d4b53a09"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check user is able to filter the list by a list of specific arm IDs
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "autoqcitem22"
    And Operator searches "arm id" with "7"
    Then Operator verifies sort belt monitoring result has arm ids matched "7"
    When Operator searches "arm id" with "10"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check user should be search multiple TIDs
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "autoqcitem22"
    And Operator searches "tracking id" with "d4bd3a08-2852-4d13-f546-74bc185b3333"
    And Operator searches "tracking id" with "d4bd3a08-2852-4d13-b230-74bc185b1245"
    Then Operator verifies sort belt monitoring result has tracking ids displayed as below:
      | d4bd3a08-2852-4d13-f546-74bc185b3333 |
      | d4bd3a08-2852-4d13-b230-74bc185b1245 |

  Scenario: Check user is not able to search multiple value on Arm ID field
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects first session
    And Operator searches "arm id" with "1, 3"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check correct data return when searching combine TID and Arm ID
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "autoqcitem22"
    And Operator searches "tracking id" with "d4bd3a08-2852-4d13-f546-74bc185b3333"
    And Operator searches "arm id" with "7"
    Then Operator verifies sort belt monitoring result has tracking ids displayed as below:
      | d4bd3a08-2852-4d13-f546-74bc185b3333 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op