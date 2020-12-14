@OperatorV2 @MiddleMile @Hub @FacilitiesManagement
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Disable Hub (<hiptest-uid>)
    Given Operator open "Facilities Management" page
    When Operator search "hub in Name"
    Then Make sure "Hub " is shown
    And Make sure "Facility Type" is "Station"
    When Operator click "Disable" button
    Then Make sure it show dialog "Confirm Deactivation" with message "Disable the selected hub will affect in removing some schedules and some paths. Are you sure you want to disable?"
    When Operator click "Disable" button
    Then Make sure "hub's status" is "Disabled"
    Examples:
      | type | hiptest-uid |
      | Station | uid:6f350889-3076-4293-992a-7b0443dac7d8 |
      | Station - Crossdock | uid:4d9e12db-b529-4b93-b7fc-776ac32bc7dc |
      | Hub - Crossdock | uid:846081f6-4fa4-4ecc-b3a4-2a2ee1e2b68e |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op