@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditDisableAirport
Feature: Port Trip Management - Edit/Disable Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Code
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
	  | portCode | GENERATED |
	And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
	And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Full Airport Name
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
	And Edit the "portName" for created Port
	  | portName | GENERATED |
	And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
	And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport's City
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
	And Edit the "city" for created Port
	  | city | Singapore |
	And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
	And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport's Region
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
	And Edit the "region" for created Port
	  | region | GW |
	And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
	And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport's Latitude
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
	  | latitude | 11 |
	And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
	And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport's Longitude
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
	  | longitude | -80 |
	And Verify the new port "Port {KEY_MM_LIST_OF_UPDATED_PORTS[1].portName} has been updated" created success message
	And Verify port "KEY_MM_LIST_OF_UPDATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Code with < 3 letters
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
	  | portCode | Z |
	And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Code with > 3 letters
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
	  | portCode | Mega |
	And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Code with 3 mix letter and number
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
	  | portCode | 12A |
	And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Edit Airport Code with existing Airport Code
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
	And Edit the "portCode" for created Port
	  | portCode | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
	And Verify the error "Duplicate Airport code. Airport code {KEY_MM_LIST_OF_UPDATED_PORTS[1].portCode} is already exists" is displayed while creating new port

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op
