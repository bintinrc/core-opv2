@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditDisableSeaport
Feature: Port Trip Management - Edit/Disable Seaport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with Seaport Code 5 numbers
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
    And Edit the "portCode" for created Port
      | portCode | NUMBER |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with Seaport Code 5 letters
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
    And Edit the "portCode" for created Port
      | portCode | GENERATED |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with Seaport Code 5 mix letter and number
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
    And Edit the "portCode" for created Port
      | portCode | ALPHANUM |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Full Seaport Name
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
    And Edit the "portName" for created Port
      | portName | GENERATED |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's City
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
    And Edit the "city" for created Port
      | city | Singapore |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Region
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
    And Edit the "region" for created Port
      | region | GW |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Latitude
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
    And Edit the "latitude" for created Port
      | latitude | 11.1 |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Longitude
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
    And Edit the "longitude" for created Port
      | longitude | -80.1 |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with < 5 characters
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
    And Edit the "portCode" for created Port
      | portCode | Z |
    And Verify the validation error "Seaport code must be 5 alphanumeric characters long." is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with > 5 characters
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
    And Edit the "portCode" for created Port
      | portCode | MegaQQ |
    And Verify the validation error "Seaport code must be 5 alphanumeric characters long." is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with 5 mix letter and number
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
    And Edit the "portCode" for created Port
      | portCode | ALPHANUM |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with existing Seaport Code
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
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 36.9220427  |
      | longitude | -80.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[2].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table
    And Edit the "portCode" for created Port
      | portCode | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Verify the error "Duplicate Seaport code. Seaport code {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} is already exists" is displayed while creating new port

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Full Seaport Name with existing Seaport Name
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
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 36.9220427  |
      | longitude | -80.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[2].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table
    And Edit the "portName" for created Port
      | portName | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Code with same Seaport Code value
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
    And Edit the "portCode" for created Port
      | portCode | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Latitude with Latitude > 90
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
    And Edit the "latitude" for created Port
      | latitude | 91 |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Longitude with Longitude > 180
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
    And Edit the "longitude" for created Port
      | longitude | 181 |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Disable Seaport
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
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Activate Seaport
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
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Activate" button on panel on Port Trip Management page
    And Verify the new port "Port successfully enabled" created success message
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Cancel Disable Seaport
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
    And Operator click on Disable button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Cancel Activate Seaport
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
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport Port Type
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
    And Edit the "portType" for created Port
      | portType | Seaport |

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Latitude with Latitude <= 90
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
      | latitude  | 89.9        |
      | longitude | -81.6894072 |
      | portType  | Seaport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Edit the "latitude" for created Port
      | latitude | 90.0 |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Seaport's Longitude with Longitude <= 180
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
    And Edit the "longitude" for created Port
      | longitude | 180.0 |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify the newly updated port values in table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
