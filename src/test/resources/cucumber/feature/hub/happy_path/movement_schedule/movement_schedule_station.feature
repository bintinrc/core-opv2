@HappyPath @Hub @InterHub @MovementSchedules @Stations
Feature: Stations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI
  Scenario: Create New Station Hub (uid:5f261101-65b8-4790-8928-d55cba446f01)
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
  Scenario: Update Hub Type to Station (uid:bae5cf22-4c6a-4984-b9ea-0666ded1818e)
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

    # TODO: IMPLEMENT ME
  Scenario: View Station Schedule - Show All Station Schedule under Selected Crossdock Hub (uid:17d9e2b0-2270-4b04-a7d5-db15cd188eb7)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: View Station Schedule - Show Station Schedules based on selected Crossdock Hub, Origin Hub and Destination Hub (uid:eabf7da9-8930-4f44-ae35-d2d3486d4e95)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Create Station Schedule - Add Schedule for New Relations (uid:0415f542-2185-42a4-bfd2-ea4dbed56b8a)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Create Station Schedule - Add Schedule for Existing Relations (uid:6bc7dd61-3868-4bb3-9dfb-388a728c02e3)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Create Station Schedule - Add Multiple Schedules (uid:4852437d-c268-4529-a2e3-9204ef59de19)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Delete Station Movement Schedule (uid:0bbb347d-4921-4eb7-868c-441f0d983fc4)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Update Station Schedule - Remove Existing Schedules (uid:12d47851-f76a-41fb-9bea-625dc1bc437d)
    Given no-op

    # TODO: IMPLEMENT ME
  Scenario: Update Station Schedule - Succeed Update Schedule (uid:d4c469cf-4f7f-41fb-9afb-2ff695479b13)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op