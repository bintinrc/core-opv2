@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @SearchTrip @SearchField @DepartureTab @AssignedTab
Feature: Movement Trip - Search Trip - Search Field - Departure Tab - Assigned Tab

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Destination Hub (uid:16123ee1-325d-4c88-959e-4d0200284ac6)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "destination_hub"
    Then Operator verifies that the trip management shown with "destination_hub" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Trip ID (uid:1213b7a3-e898-4d23-ac5a-874bf6d094ee)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Movement Type (uid:e1cbce83-f057-4c8f-9b5f-c7f58fec21e1)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Expected Departure Time (uid:a403748d-4656-40e7-a826-2882fa76663f)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Arrival Time (uid:86d46d08-f937-4c9b-a98e-ae5ca423bac6)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Driver (uid:9cf00b01-0d91-46cb-b994-428957439a03)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And DB Operator gets the driver name by driver id for Trip Management
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Status (uid:4467d634-3a90-4981-b610-2ae44669ab47)
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
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator assign driver "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to movement trip schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}"
    And API Operator depart trip with data below:
      | movementTripId | {KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id} |
      | tripId         | {KEY_LIST_OF_CURRENT_MOVEMENT_TRIP_IDS[1]}              |
    And Operator refresh page
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{KEY_LIST_OF_CREATED_HUBS[1].id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op