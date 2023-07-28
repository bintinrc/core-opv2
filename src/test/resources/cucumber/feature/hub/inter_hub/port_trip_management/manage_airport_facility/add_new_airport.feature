@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AddNewAirport
Feature: Port Trip Management - Add New Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport
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

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with existing Airport Code
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
	  | portCode  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
	  | portName  | GENERATED                                  |
	  | city      | Singapore                                  |
	  | region    | GW                                         |
	  | latitude  | 20.9220427                                 |
	  | longitude | -11.6894072                                |
	  | portType  | Airport                                    |
	And Verify the error "Duplicate Airport code. Airport code {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} is already exists" is displayed while creating new port

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with existing Airport Name
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
	  | portCode  | GENERATED                                  |
	  | portName  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
	  | city      | Singapore                                  |
	  | region    | GW                                         |
	  | latitude  | 20.9220427                                 |
	  | longitude | -11.6894072                                |
	  | portType  | Airport                                    |
	And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[2].portName} has been created" created success message
	And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Latitude > 90
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
	  | portType  | Airport     |
	And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Longitude > 180
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
	  | portType  | Airport   |
	And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Duplicate Airport Details
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
	  | portCode  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} |
	  | portName  | GENERATED                                  |
	  | city      | SG                                         |
	  | region    | JKB                                        |
	  | latitude  | 37.9220427                                 |
	  | longitude | -81.6894072                                |
	  | portType  | Airport                                    |
	And Verify the error "Duplicate Airport code. Airport code {KEY_MM_LIST_OF_CREATED_PORTS[1].portCode} is already exists" is displayed while creating new port

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with existing Airport Details exclude Airport Code
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
	  | portCode  | GENERATED                                  |
	  | portName  | {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} |
	  | city      | SG                                         |
	  | region    | JKB                                        |
	  | latitude  | 37.9220427                                 |
	  | longitude | -81.6894072                                |
	  | portType  | Airport                                    |
	And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[2].portName} has been created" created success message
	And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[2]" values in table

  @HappyPath @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Airport Code > 3 characters
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	Given Operator refresh page v1
	And Operator verifies that the Port Management Page is opened
	When Operator click on Manage Port Facility and verify all components
	Then Operator Add new Port
	  | portCode  | AVRA        |
	  | portName  | GENERATED   |
	  | city      | SG          |
	  | region    | JKB         |
	  | latitude  | 37.9220427  |
	  | longitude | -81.6894072 |
	  | portType  | Airport     |
	And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Airport Code < 3 characters
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	Given Operator refresh page v1
	And Operator verifies that the Port Management Page is opened
	When Operator click on Manage Port Facility and verify all components
	Then Operator Add new Port
	  | portCode  | AV          |
	  | portName  | GENERATED   |
	  | city      | SG          |
	  | region    | JKB         |
	  | latitude  | 37.9220427  |
	  | longitude | -81.6894072 |
	  | portType  | Airport     |
	And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Latitude <= 90
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
	  | latitude  | 90          |
	  | longitude | -81.6894072 |
	  | portType  | Airport     |
	And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
	And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Add New Airport with Longitude <= 180
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
	  | latitude  | 90        |
	  | longitude | 180       |
	  | portType  | Airport   |
	And Verify the new port "Port {KEY_MM_LIST_OF_CREATED_PORTS[1].portName} has been created" created success message
	And Verify port "KEY_MM_LIST_OF_CREATED_PORTS[1]" values in table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op
