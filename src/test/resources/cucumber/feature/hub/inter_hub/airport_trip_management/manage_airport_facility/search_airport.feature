@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @ManageAirportFacility @SearchAirport @CWF
Feature: Airport Trip Management - Manage Airport Facility - Search Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Search Airport on Search Field ID (uid:13edbee7-5950-4b95-a8a6-a965a7a59bfc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | 166   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    And Operator search airport by "ID"
    Then Operator verifies the search airport on Airport Facility page

  @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Search Airport on Search Field Airport Code (uid:0ba1aeca-ca8a-4175-a85c-af50f96f4537)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | 166   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    And Operator search airport by "Airport Code"
    Then Operator verifies the search airport on Airport Facility page

  @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Search Airport on Search Field Full Airport Name (uid:4f7720e3-bf78-4e66-b5e1-b3a55256dc3e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | 166   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    And Operator search airport by "Airport Name"
    Then Operator verifies the search airport on Airport Facility page

  @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Search Airport on Search Field City (uid:54110c90-5f98-4c4c-9fcd-cc7cfd8645e5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | 166   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    And Operator search airport by "City"
    Then Operator verifies the search airport on Airport Facility page

  @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Search Airport on Search Field Region (uid:88e8a7c4-fe4d-4137-aaa4-809904671ad8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | 166   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    And Operator search airport by "Region"
    Then Operator verifies the search airport on Airport Facility page

  @DeleteCreatedAirports @DeleteAirportsViaAPI @RT
  Scenario: Search Airport on Search Field Latitude, Longitude (uid:c342590e-79e1-4543-975b-5ddae47d0ca3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new airport using data below:
      | system_id     | SG          |
      | airportCode   | 166   |
      | airportName   | GENERATED   |
      | city          | GENERATED   |
      | latitude      | GENERATED   |
      | longitude     | GENERATED   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    And Operator search airport by "latitude, longitude"
    Then Operator verifies the search airport on Airport Facility page

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
