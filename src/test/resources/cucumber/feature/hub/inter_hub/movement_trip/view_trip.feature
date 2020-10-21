@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @ViewTrip
Feature: Movement Trip - View Trips

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb
  Scenario: View Departure Trip (uid:fd9d635c-5dc2-4e14-8344-20b7acb3f984)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {hub-relation-origin-hub-id} to hub id = {KEY_LIST_OF_CREATED_HUBS[1].id}
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened

  @DeleteDriver @DeleteHubsViaDb
  Scenario: View Arrival Trip (uid:567dc293-b7c3-441a-8f00-2998fad953a9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{KEY_LIST_OF_CREATED_HUBS[2].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened

  Scenario: View Archived Trip (uid:f88425c2-6cb1-44d5-a9ff-d87abf1cf31b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
