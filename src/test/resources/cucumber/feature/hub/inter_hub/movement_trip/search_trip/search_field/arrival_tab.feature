@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @SearchTrip @SearchField @ArrivalTab
Feature: Movement Trip - Search Trip - Search Field - Arrival Tab

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Trip on Search Field - Arrival Tab - Search Origin Hub (uid:9ec65ffc-1219-4cf3-877c-c39f5c14954f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{hub-relation-destination-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-destination-hub-id}"
    And Operator searches for the Trip Management based on its "origin_hub"
    Then Operator verifies that the trip management shown with "origin_hub" as its filter is right

  Scenario: Search Trip on Search Field - Arrival Tab - Search Trip ID (uid:cbafa53a-3ce4-4e92-993c-21d3ead034b3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{hub-relation-destination-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-destination-hub-id}"
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: Search Trip on Search Field - Arrival Tab - Search Movement Type (uid:f7683073-37be-40f9-994e-e2feac804839)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{hub-relation-destination-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: Search Trip on Search Field - Arrival Tab - Search Expected Departure Time (uid:c6b58cec-b1d8-46b8-b417-0396e7104101)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{hub-relation-destination-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-destination-hub-id}"
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: Search Trip on Search Field - Arrival Tab - Search Actual Departure Time (uid:812c3ddf-021f-4611-af81-6703bc69a6b5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{KEY_LIST_OF_CREATED_HUBS[2].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the destination hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And Operator searches for the Trip Management based on its "actual_departure_time"
    Then Operator verifies that the trip management shown with "actual_departure_time" as its filter is right

  @DeleteDriver @DeleteHubsViaAPI @DeleteHubsViaDb
  Scenario: Search Trip on Search Field - Arrival Tab - Search Expected Arrival Time (uid:c519dd8f-6df1-4d9a-bb75-a60432661ada)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 2 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}" plus hours 1
    And API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{KEY_LIST_OF_CREATED_HUBS[2].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the destination hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And Operator searches for the Trip Management based on its "expected_arrival_time" on arrival tab
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right on arrival tab

  Scenario: Search Trip on Search Field - Arrival Tab - Search Driver (uid:092ae7a3-2960-4987-862c-b11d68101f50)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{hub-relation-destination-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: Search Trip on Search Field - Arrival Tab - Search Status (uid:05e8153e-627b-4f44-b08f-b5e937e02456)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator searches and selects the "destination hub" with value "{hub-relation-destination-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op