@OperatorV2 @OperatorV2Part2 @FacilitiesManagement @Saas
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to create a new Hub on page Hubs Administration (uid:c753d5ed-1026-408e-9c71-0e5b8f4e7aa3)
    Given Operator go to menu Hubs -> Facilities Management
    When Operator create new Hub on page Hubs Administration using data below:
      | name        | GENERATED |
      | displayName | GENERATED |
      | city        | GENERATED |
      | country     | GENERATED |
      | latitude    | GENERATED |
      | longitude   | GENERATED |
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to update Hub on page Hubs Administration (uid:aca32744-d848-4506-a5f0-b2736dc19987)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    When Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name}          |
      | name              | {KEY_CREATED_HUB.name} [E]      |
      | displayName       | {KEY_CREATED_HUB.shortName} [E] |
      | city              | GENERATED                       |
      | country           | GENERATED                       |
      | latitude          | GENERATED                       |
      | longitude         | GENERATED                       |
    Then Operator verify Hub is updated successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to search Hub on page Hubs Administration (uid:94222294-3788-453b-90c4-86f9bd751641)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
    Then Operator verify Hub is found on Facilities Management page and contains correct info

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to download Hub CSV file and verify the contents is correct on page Hubs Administration (uid:2a3dd749-c251-45a7-893b-84b8611f5665)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    When Operator download Hub CSV file on Facilities Management page
    Then Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator Refresh Hub Cache
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator refresh hubs cache on Facilities Management page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator Disable active hub
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator activate created hub
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    When Operator disable created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator Activate disabled hub
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator disable created hub
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    When Operator activate created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
