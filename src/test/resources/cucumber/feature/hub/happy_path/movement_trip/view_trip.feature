@OperatorV2 @HappyPath @Hub @InterHub @MovementTrip @ViewTrip
Feature: Movement Trip - View Trips

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI
  Scenario: View Departure Trip (uid:b297f8a1-7178-4c17-9e07-0311edbff9fb)
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
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened

  @DeleteDriver @DeleteHubsViaAPI
  Scenario: View Arrival Trip (uid:78d3df1b-2cb5-488f-a49a-ada0ed15a7a8)
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
    When Operator searches and selects the "destination hub" with value "{KEY_LIST_OF_CREATED_HUBS[2].name}"
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened

  Scenario: View Archived Trip (uid:fefeff08-f1c7-4e55-98cd-c43d518f7c69)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened

  @DeleteHubsViaAPI
  Scenario: Cancel Trip - Trip Status Pending (uid:e5ef8333-b536-49dd-8d34-e5180c646837)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[2].name}" exist
    And Operator searches for Movement Trip based on status "pending"
    When Operator clicks on "cancel" icon on the action column
    And Operator clicks "Cancel Trip" button on cancel trip dialog
    And Operator verifies that there will be a movement trip cancelled toast shown
    And Operator searches for Movement Trip based on status "cancelled"
    Then Operator verifies movement trip shown has status value "cancelled"
    And DB Operator verifies movement trip has event with status cancelled

  @DeleteHubsViaAPI
  Scenario: Cancel Trip - Trip Status Transit (uid:a6663576-da9a-40fb-807b-0e389322fba5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement trip schedule
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And API Operator updates movement trip status to transit
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[2].name}" exist
    And Operator searches for Movement Trip based on status "transit"
    When Operator clicks on "cancel" icon on the action column
    And Operator clicks "Cancel Trip" button on cancel trip dialog
    And Operator verifies that there will be a movement trip cancelled toast shown
    And Operator searches for Movement Trip based on status "cancelled"
    Then Operator verifies movement trip shown has status value "cancelled"
    And DB Operator verifies movement trip has event with status cancelled

  @DeleteHubsViaAPI
  Scenario: Cannot Cancel Invalid Trip - Trip status Completed (uid:1aefeba5-dbd3-4515-912f-f7c8e05108d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    Given API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator verify new Hubs are created
    And API Operator reloads hubs cache
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver to movement trip schedule
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And API Operator updates movement trip status to transit
    And API Operator updates movement trip status to completed
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[2].name}" exist
    And Operator searches for Movement Trip based on status "completed"
    Then Operator verifies "cancel" button disabled

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
