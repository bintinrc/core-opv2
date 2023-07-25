@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditDisableAirport2
Feature: Port Trip Management - Edit/Disable Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Full Airport Name with existing Airport Name
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    Then Operator Add new Port
      | portCode  | GENERATED   |
      | portName  | GENERATED   |
      | city      | SG          |
      | region    | JKB         |
      | latitude  | 36.9220427  |
      | longitude | -80.6894072 |
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[2].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table
    And Edit the "portName" for created Port
      | portName | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Code with same Airport Code value
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Edit the "portCode" for created Port
      | portCode | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
    And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
    And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport's Latitude with Latitude > 90
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Edit the "latitude" for created Port
      | latitude | 91 |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport's Longitude with Longitude > 180
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Edit the "longitude" for created Port
      | longitude | 181 |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Disable Airport
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Activate Airport
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
      | portType  | Airport     |
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
  Scenario: Cancel Disable Airport
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Cancel Activate Airport
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Port Type
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
      | portType  | Airport     |
    And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
    And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table
    And Edit the "portType" for created Port
      | portType | Seaport |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
