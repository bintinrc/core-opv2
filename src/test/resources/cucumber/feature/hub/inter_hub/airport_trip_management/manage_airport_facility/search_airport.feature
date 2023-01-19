@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @ManageAirportFacility @SearchAirport
Feature: Airport Trip Management - Manage Airport Facility - Search Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "ID"
    Then Operator verifies the search port on Port Facility page

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field Port Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Code"
    Then Operator verifies the search port on Port Facility page

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field Port Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Type"
    Then Operator verifies the search port on Port Facility page

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field Full Port Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Name"
    Then Operator verifies the search port on Port Facility page

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field City
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "City"
    Then Operator verifies the search port on Port Facility page

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field Region
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Region"
    Then Operator verifies the search port on Port Facility page

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field Latitude, Longitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Operator create new port using data below:
      | system_id | SG        |
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | GENERATED |
      | latitude  | GENERATED |
      | longitude | GENERATED |
      | portType  | Airport   |
    And API Operator refresh Airports cache
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "latitude, longitude"
    Then Operator verifies the search port on Port Facility page

  Scenario: No Data Found Search Airport on Search Field ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "ID"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Port Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Code"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Port Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Type"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Full Port Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Name"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field City
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "City"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Region
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Region"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Latitude, Longitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "latitude, longitude"
    Then Operator verifies that no data appear on Port Facility page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
