@OperatorV2 @MiddleMile @Hub @FacilitiesManagement
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb
  Scenario Outline: Disable Hub - (<type>) (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub with type "<type>" using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given Operator go to menu Hubs -> Facilities Management
    When Operator search "hub in Name" in facilities management page
    Then Make sure "Hub " is shown
    And Make sure "Facility Type" is "<type>"
    When Operator click "Disable" button in facilities management page
    Then Make sure it show dialog "Confirm Deactivation" with message "Disable the selected hub will affect in removing some schedules and some paths. Are you sure you want to disable?"
    When Operator click "Disable" button in disable hub modal
    Then Make sure "hub's status" is "Disabled"
    Examples:
      | type                | hiptest-uid                              |
      | Station             | uid:6f350889-3076-4293-992a-7b0443dac7d8 |
      | Station - Crossdock | uid:4d9e12db-b529-4b93-b7fc-776ac32bc7dc |
      | Hub - Crossdock     | uid:846081f6-4fa4-4ecc-b3a4-2a2ee1e2b68e |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op