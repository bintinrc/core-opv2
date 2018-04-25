@OperatorV2 @ThirdPartyShippers
Feature: Third Party Shippers

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create new Third Party Shippers (uid:43e49845-b93e-4fc5-9c69-77b83a0d213a)
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  Scenario: Operator edit Third Party Shippers (uid:1b1ed351-c102-4322-b8a9-d8f2f0a6c9ba)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully
    When Operator update the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is updated successfully
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  Scenario: Operator delete Third Party Shippers (uid:5721e3a0-fd13-4a33-9ad1-88da41024e8f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  Scenario: Operator check all filters on Third Party Shippers page work fine (uid:6acb8ac3-bfa1-44b8-9c13-1be9a15b7bdd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully
    Then Operator check all filters on Third Party Shippers page work fine
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  Scenario: Operator download and verify Third Party Shippers CSV file (uid:867ffa72-6835-4c83-9462-470e2e4ec4d0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Shippers
    When Operator create new Third Party Shippers
    Then Operator verify the new Third Party Shipper is created successfully
    When Operator download Third Party Shippers CSV file
    Then Operator verify Third Party Shippers CSV file downloaded successfully
    When Operator delete the new Third Party Shipper
    Then Operator verify the new Third Party Shipper is deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
