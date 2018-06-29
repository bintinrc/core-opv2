@OperatorV2 @HubsAdministration @Saas2
Feature: Hubs Administration

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to create a new Hub on page Hubs Administration (uid:c753d5ed-1026-408e-9c71-0e5b8f4e7aa3)
    Given Operator go to menu Hubs -> Hubs Administration
    When Operator create new Hub on page Hubs Administration using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Then Operator verify a new Hub is created successfully on page Hubs Administration

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to update Hub on page Hubs Administration (uid:aca32744-d848-4506-a5f0-b2736dc19987)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Hubs -> Hubs Administration
    When Operator create new Hub on page Hubs Administration using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Then Operator verify a new Hub is created successfully on page Hubs Administration
    When Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | GET_FROM_CREATED_HUB_NAME |
      | name              | GENERATED                 |
      | displayName       | GENERATED                 |
      | city              | GENERATED                 |
      | country           | GENERATED                 |
      | latitude          | GENERATED                 |
      | longitude         | GENERATED                 |
    Then Operator verify Hub is updated successfully on page Hubs Administration

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to search Hub on page Hubs Administration (uid:94222294-3788-453b-90c4-86f9bd751641)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Hubs -> Hubs Administration
    When Operator create new Hub on page Hubs Administration using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Then Operator verify a new Hub is created successfully on page Hubs Administration
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | GET_FROM_CREATED_HUB_NAME |
    Then Operator verify Hub is found on page Hubs Administration and contains correct info

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to download Hub CSV file and verify the contents is correct on page Hubs Administration (uid:2a3dd749-c251-45a7-893b-84b8611f5665)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Hubs -> Hubs Administration
    When Operator create new Hub on page Hubs Administration using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Then Operator verify a new Hub is created successfully on page Hubs Administration
    When Operator download Hub CSV file on page Hubs Administration
    Then Operator verify Hub CSV file is downloaded successfully on page Hubs Administration and contains correct info

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
