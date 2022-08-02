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
    Then Operator verifies sort belt monitoring result has "hub" matched search term "{hub-id}"
    When Operator searches "hub" with "{invalid-id}"
    Then Operator verifies there is no results displayed in session list
    When Operator searches "hub" with "{hub-name}"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "{hub-name}"
    When Operator searches "hub" with "{invalid-name}"
    Then Operator verifies there is no results displayed in session list

  Scenario: Check user should be able to filter the list by DEVICE ID/Name
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "device" with "{device-id}"
    Then Operator verifies sort belt monitoring result has "device" matched search term "{device-id}"
    When Operator searches "device" with "{invalid-id}"
    Then Operator verifies there is no results displayed in session list
    When Operator searches "device" with "{device-name}"
    Then Operator verifies sort belt monitoring result has "device" matched search term "{device-name}"
    When Operator searches "device" with "{invalid-name}"
    Then Operator verifies there is no results displayed in session list

  Scenario: Check displays correct result when filtering Start Date and End Date
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects "start time" as "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    And Operator selects "end time" as "{gradle-next-1-date-dd/MM/yyyy-HH:mm}"
    Then Operator verifies Start time after "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    And Operator verifies Completed time before "{gradle-next-1-date-dd/MM/yyyy-HH:mm}"

  Scenario: Check displays correct result when filtering HubID and Device ID and Start time and end time
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator searches "hub" with "{hub-id}"
    And Operator searches "device" with "{device-name}"
    And Operator selects "start time" as "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    And Operator selects "end time" as "{gradle-next-1-date-dd/MM/yyyy-HH:mm}"
    Then Operator verifies sort belt monitoring result has "hub" matched search term "{hub-id}"
    And Operator verifies sort belt monitoring result has "device" matched search term "{device-name}"
    And Operator verifies Start time after "{gradle-previous-10-date-dd/MM/yyyy-HH:mm}"
    And Operator verifies Completed time before "{gradle-next-1-date-dd/MM/yyyy-HH:mm}"

  Scenario:  Check user able to filter the list by a list of specific Tracking IDs
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "{session-name}"
    And Operator searches "tracking id" with "{tracking-id}"
    Then Operator verifies sort belt monitoring result has tracking ids displayed as below:
      | {tracking-id} |
    When Operator clears all search fields
    And Operator searches "tracking id" with "{invalid-id}"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check user is able to filter the list by a list of specific arm IDs
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "{session-name}"
    And Operator searches "arm id" with "{arm-id}"
    Then Operator verifies sort belt monitoring result has arm ids matched "7"
    When Operator searches "arm id" with "{invalid-arm-id}"
    Then Operator verifies there is no results displayed in tracking list

  Scenario: Check user should be search multiple TIDs
    Given Operator go to menu Sort -> Sort Belt Monitoring
    And Operator waits until sort belt monitoring page loaded
    And Operator clears all search fields
    When Operator selects session name "{session-name}"
    And Operator searches "tracking id" with "{tracking-id-1}"
    And Operator searches "tracking id" with "{tracking-id-2}"
    Then Operator verifies sort belt monitoring result has tracking ids displayed as below:
      | {tracking-id-1} |
      | {tracking-id-2} |

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
    When Operator selects session name "{session-name}"
    And Operator searches "tracking id" with "{tracking-id-1}"
    And Operator searches "arm id" with "{arm-id}"
    Then Operator verifies sort belt monitoring result has tracking ids displayed as below:
      | {tracking-id-1} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op