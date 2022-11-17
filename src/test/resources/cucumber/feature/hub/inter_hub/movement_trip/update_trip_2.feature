@Hub @InterHub @MiddleMile @TripManagement @MovementTrip @UpdateTrip2
Feature: Movement Trip - Update Trip 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Force Complete Departed Trip via Trip Details page - In Transit Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 4 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[3].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[4].name}" exist
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened
    When Operator depart trip
    When Operator clicks Force Completion button on Movement Trips page
    And Operator depart trip
    And Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" display on Movement Trip details page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Force Complete Arrived Trip via Trip Details page - Incomplete Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 4 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[3].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[4].name}" exist
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    When Operator clicks on "view" icon on the action column
    Then Operator verifies that the new tab with trip details is opened
    And Operator depart trip
    When Operator clicks Force Completion button on Movement Trips page
    And Operator depart trip
    And Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" display on Movement Trip details page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Force Complete Departed Trip via Movement Trip Table page - In Transit Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 4 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[3].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[4].name}" exist
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And Operator depart trip
    When Operator clicks Force Completion button on Movement Trips page
    And Operator depart trip
    And Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" display on Movement Trip details page

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteDriver
  Scenario: Force Complete Arrived Trip via Movement Trip Table page - Incomplete Trip
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator creates 4 new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[2].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And API Operator arrival trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    Given API Operator create new "CROSSDOCK" movement schedule with type "LAND_HAUL" from hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}" to hub id = "{KEY_LIST_OF_CREATED_HUBS[4].id}"
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[2].id}"
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[3].name}"
    And Operator clicks on Load Trip Button
    And Operator verifies a trip to destination hub "{KEY_LIST_OF_CREATED_HUBS[4].name}" exist
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[3].id}"
    And Operator depart trip
    When Operator clicks Force Completion button on Movement Trips page
    And Operator depart trip
    And Operator verifies trip message "Trip {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[2]} departed" display on Movement Trip details page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op