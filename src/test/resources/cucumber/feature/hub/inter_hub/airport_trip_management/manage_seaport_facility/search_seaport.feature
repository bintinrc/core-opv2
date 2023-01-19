@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @ManageAirportFacility @SearchAirport
Feature: Airport Trip Management - Manage Airport Facility - Search Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Search Airport on Search Field ID (uid:13edbee7-5950-4b95-a8a6-a965a7a59bfc)
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
  Scenario: Search Airport on Search Field Airport Code (uid:0ba1aeca-ca8a-4175-a85c-af50f96f4537)
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
  Scenario: Search Airport on Search Field Full Airport Name (uid:4f7720e3-bf78-4e66-b5e1-b3a55256dc3e)
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
  Scenario: Search Airport on Search Field City (uid:54110c90-5f98-4c4c-9fcd-cc7cfd8645e5)
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
  Scenario: Search Airport on Search Field Region (uid:88e8a7c4-fe4d-4137-aaa4-809904671ad8)
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
  Scenario: Search Airport on Search Field Latitude, Longitude (uid:c342590e-79e1-4543-975b-5ddae47d0ca3)
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

  Scenario: No Data Found Search Airport on Search Field ID (uid:46cee705-ef06-4f9c-a35f-8943c53e0c1c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "ID"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Airport Code (uid:49003b4a-8f3b-4fe0-bccf-37f149f82405)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Code"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Full Airport Name (uid:6cbe0dd6-b6f6-4760-adc5-9fd766206329)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Port Name"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field City (uid:ffc73967-630a-49ee-8155-93ce0337db6d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "City"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Region (uid:f68eb43f-8ef1-4906-9b05-0a719cc35fc9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "Region"
    Then Operator verifies that no data appear on Port Facility page

  Scenario: No Data Found Search Airport on Search Field Latitude, Longitude (uid:808c46a9-c764-4cdc-be3a-bc2911e23c5f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    And Operator search port by "latitude, longitude"
    Then Operator verifies that no data appear on Port Facility page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
