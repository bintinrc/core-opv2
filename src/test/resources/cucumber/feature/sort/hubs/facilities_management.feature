@Sort @Hubs @FacilitiesManagement @Saas
Feature: Facilities Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @SoftDeleteHubViaDb
  Scenario: Create Hub (uid:c40d8354-a4cb-463c-a220-39f56e91eb71)
    Given Operator go to menu Hubs -> Facilities Management
    When Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Update Hub (uid:16ec1eac-f4f4-495a-8b71-4f8a9d846e54)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
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
    And Operator refresh page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Search Hub (uid:449beef4-34f3-42ad-8c08-026938ae42db)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    And Operator go to menu Hubs -> Facilities Management
    When Operator search Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
    Then Operator verify Hub is found on Facilities Management page and contains correct info

  @SoftDeleteHubViaDb
  Scenario: Download CSV hubs (uid:382e0a13-8725-42ae-995c-e6f524961fa7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator go to menu Hubs -> Facilities Management
    And Operator refresh hubs cache on Facilities Management page
    And Operator refresh page
    When Operator download Hub CSV file on Facilities Management page
    Then Operator verify Hub CSV file is downloaded successfully on Facilities Management page and contains correct info

  @SoftDeleteHubViaDb
  Scenario: Refresh Hub Cache (uid:eed1ef3e-e148-45a8-a677-c97e6e228ecd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And Operator go to menu Hubs -> Facilities Management
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator refresh page
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Disable active hub (uid:667d6ff4-6483-490e-a4ea-0513741d00ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator activate created hub
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh page
    And Operator disable created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Activate disabled hub (uid:60f0c3fc-649b-4018-9952-23bd208b4374)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator disable created hub
    When Operator go to menu Hubs -> Facilities Management
    And Operator refresh hubs cache on Facilities Management page
    And Operator refresh page
    And Operator activate created hub on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Create New Station Hub (uid:8f0ca3bd-c928-4bc9-b759-5fcdfeb9ea98)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Hubs -> Facilities Management
    And Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | displayName  | GENERATED |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Update Hub Type to Station (uid:4aae1605-d328-4259-9fda-e0b742e9910d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    When Operator go to menu Hubs -> Facilities Management
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
    And Operator refresh hubs cache on Facilities Management page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @SoftDeleteHubViaDb
  Scenario: Create New Hub-Crossdock Not As Sort Hub (uid:9fbaa3fa-8415-456e-acf1-f68dd496ed26)
    Given Operator go to menu Hubs -> Facilities Management
    When Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page
    And DB Operator verify a new hub is created in core.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
      | sortHub      | 0                      |

  @SoftDeleteHubViaDb
  Scenario: Create New Hub-Crossdock As Sort Hub (uid:a2a0ab06-4a7a-42c1-8aed-eb29bf9c9f40)
    Given Operator go to menu Hubs -> Facilities Management
    When Operator create new Hub on page Hubs Administration using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
      | sortHub      | YES       |
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page
    And DB Operator verify a new hub is created in core.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
    And DB Operator verify a new hub is created in sort.hubs using data below:
      | hubName      | {KEY_CREATED_HUB.name} |
      | facilityType | CROSSDOCK              |
      | sortHub      | 1                      |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op