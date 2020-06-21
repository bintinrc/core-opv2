@OperatorV2 @Hubs @OperatorV2Part2 @FacilitiesManagement @Saas
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
    And Operator refresh page
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
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name}          |
      | name              | {KEY_CREATED_HUB.name} [E]      |
      | displayName       | {KEY_CREATED_HUB.shortName} [E] |
      | city              | GENERATED                       |
      | country           | GENERATED                       |
      | latitude          | GENERATED                       |
      | longitude         | GENERATED                       |
    And Operator refresh hubs cache on Facilities Management page
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
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator search Hub on page Hubs Administration using data below:
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
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator download Hub CSV file on Facilities Management page
    Then Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator Refresh Hub Cache (uid:4f3b2cac-0f8b-4280-be3b-e30260fe582b)
    When Operator go to menu Hubs -> Facilities Management
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator Disable active hub (uid:da54b8e3-cc63-4c74-95ad-15f7cab1c2b8)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator activate created hub
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator disable created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator Activate disabled hub (uid:a157bbd1-e008-4abd-8b92-051d010465cb)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator disable created hub
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator activate created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Create New Station Hub (uid:e77343dc-f894-4a40-b1c4-abe0caab13c5)
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | facilityType | STATION   |
      | displayName  | GENERATED |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @ArchiveAndDeleteHubViaDb
  Scenario: Update Hub Type to Station (uid:f8a6ddf8-0386-4cb6-9d10-9c2bc21f6bd0)
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op