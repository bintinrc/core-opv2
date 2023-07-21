@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AddNewSeaport
Feature: Port Trip Management - Add New Seaport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Seaport Code 5 numbers
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | NUMBER      |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Seaport Code 5 letters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Seaport Code 5 mix letter and number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ALPHANUM    |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Seaport Code > 5 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJDABAB    |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the validation error "Seaport code must be 5 alphanumeric characters long." is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Seaport Code < 5 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AA          |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the validation error "Seaport code must be 5 alphanumeric characters long." is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Duplicate Seaport Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    Then Operator Add new Port
      | portCode  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | portName  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
      | city      | SG                                         |
      | region    | JKB                                        |
      | latitude  | 37.9220427                                 |
      | longitude | -81.6894072                                |
      | portType  | Seaport                                    |
    And Verify the error "Duplicate Seaport code. Seaport code {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} is already exists" is displayed while creating new port

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with existing Seaport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    Then Operator Add new Port
      | portCode  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
      | portName  | GENERATED                                  |
      | city      | SG                                         |
      | region    | JKB                                        |
      | latitude  | 37.9220427                                 |
      | longitude | -81.6894072                                |
      | portType  | Seaport                                    |
    And Verify the error "Duplicate Seaport code. Seaport code {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} is already exists" is displayed while creating new port

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with existing Seaport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    Then Operator Add new Port
      | portCode  | GENERATED                                  |
      | portName  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
      | city      | Singapore                                  |
      | region    | GW                                         |
      | latitude  | 20.9220427                                 |
      | longitude | -11.6894072                                |
      | portType  | Seaport                                    |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 95.922      |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | SG        |
      | region    | JKB       |
      | latitude  | 15.922    |
      | longitude | 181       |
      | portType  | Seaport   |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with existing Seaport Details exclude Seaport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 37.9220427  |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    Then Operator Add new Port
      | portCode  | GENERATED                                  |
      | portName  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
      | city      | SG                                         |
      | region    | JKB                                        |
      | latitude  | 37.9220427                                 |
      | longitude | -81.6894072                                |
      | portType  | Seaport                                    |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Latitude <= 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 87.9        |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Seaport with Longitude <= 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GENERATED |
      | portName  | GENERATED |
      | city      | SG        |
      | region    | JKB       |
      | latitude  | 89.9      |
      | longitude | 179.9     |
      | portType  | Seaport   |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
