@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @AssignDriver @Refo
Feature: Movement Trip - Assign Driver

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaDb @DeleteDriver @DeleteAllCreatedMovementTripsViaDb
  Scenario: Assign Single Driver to Movement Trips (uid:4cf35840-44dd-4573-bdb1-a51ac7f58984)
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
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"08176586525"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id},"hub":"{hub-name}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"password","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new "CROSSDOCK" movement schedule with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {hub-relation-destination-hub-id}
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    And Operator refresh page
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{KEY_LIST_OF_CREATED_HUBS[1].name}"
    And Operator clicks on Load Trip Button
    And Operator verify Load Trip Button is gone
    And Operator clicks on "assign_driver" icon on the action column
    And Operator assign driver "({KEY_LIST_OF_CREATED_DRIVERS[1].username})" to created movement trip
    Then Operator verifies toast with message "1 driver(s) successfully assigned to the trip" is shown on Trip Management page

  Scenario: Assign Multiple Drivers to Movement Trips (uid:86a95c5c-3388-4d14-b86c-ecd555e3bd1a)
    Given no-op

  Scenario: Assign Single Driver to Movement Schedules (uid:81f0d3b3-b58d-47a8-8905-c2ed2d4b9bac)
    Given no-op

  Scenario: Assign Multiple Drivers to Movement Schedules (uid:885d2bf7-d835-4229-b941-2758fa385163)
    Given no-op

  Scenario: Re-assign Single Driver to Movement Trips (uid:ad5ca7e3-786a-46c9-93df-9df5688a13aa)
    Given no-op

  Scenario: Re-assign Multiple Drivers to Movement Trips (uid:75e4b643-7e89-4eec-9fd4-078b46be01d4)
    Given no-op

  Scenario: Re-assign Single Driver to Movement Schedules (uid:07835418-c030-4c5d-9402-cc2f2c739df3)
    Given no-op

  Scenario: Re-assign Multiple Drivers to Movement Schedules (uid:bc5b0feb-ddfd-4914-bb99-cf4d484b8627)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op