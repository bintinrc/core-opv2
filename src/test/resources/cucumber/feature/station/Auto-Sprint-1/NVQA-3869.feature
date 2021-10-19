@StationHome @Story-1
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Case-1
  Scenario: Case-1
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"
    And updates station hub-id as "{hub-id-2}" directly in the url
    And verifies that the hub has changed to:"{hub-name-2}" in header dropdown
    And reloads operator portal to reset the test state

  @Case-2 @Pending
  Scenario Outline: Case-2
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"
    And updates station hub-id as "<InvalidHubId>" directly in the url
    Then verifies that the toast message "<ToastMessage>" is displayed
    And verifies that station management home screen url is loaded
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"

  Examples:
    | InvalidHubId | ToastMessage   |
    | 997          |  Hub not found |

  @Case-3
  Scenario: Case-3
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"
    Then Operator changes hub as "{hub-name-2}" through the dropdown in header
    And verifies that the url path parameter changes to hub-id:"{hub-id-2}"
    And reloads operator portal to reset the test state

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op