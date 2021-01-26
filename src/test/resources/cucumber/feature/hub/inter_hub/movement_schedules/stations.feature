@MiddleMile @Hub @InterHub @MovementSchedules @Stations
Feature: Stations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI
  Scenario: Create New Station Hub (uid:db3123ca-4459-49bf-88fe-1bccd5c6203b)
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
    And Operator refresh hubs cache on Facilities Management page
    And Operator refresh page
    Then Operator verify a new Hub is created successfully on Facilities Management page

  @DeleteHubsViaAPI
  Scenario: Update Hub Type to Station (uid:ef20d628-b61d-473a-b9c1-30c0f63d9b5e)
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
    And Operator refresh hubs cache on Facilities Management page
    And Operator refresh page
    And Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_CREATED_HUB.name} |
      | facilityType      | Station                |
    And Operator refresh page
    Then Operator verify Hub is updated successfully on Facilities Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op