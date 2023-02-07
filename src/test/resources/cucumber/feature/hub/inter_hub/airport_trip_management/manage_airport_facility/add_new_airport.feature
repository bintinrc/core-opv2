@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AddNewAirport
Feature: Port Trip Management - Add New Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Add New Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | SDI          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Airport with existing Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | XJT              |
      | portName  | XJT Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port XJT Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | XJT              |
      | portName  | New Test Airport |
      | city      | Singapore        |
      | region    | GW               |
      | latitude  | 20.9220427       |
      | longitude | -11.6894072      |
      | portType  | Airport          |
    And Verify the error "Duplicate Airport code. Airport code XJT is already exists" is displayed while creating new port

  @DeleteCreatedPorts
  Scenario: Add New Airport with existing Airport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OZZ               |
      | portName  | Auto Test Airport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Airport           |
    And Verify the new port "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | LFH               |
      | portName  | Auto Test Airport |
      | city      | Singapore         |
      | region    | GW                |
      | latitude  | 20.9220427        |
      | longitude | -11.6894072       |
      | portType  | Airport           |
    And Verify the new port "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Airport with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | APF          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 95.922       |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Airport with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | FEA          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 15.922       |
      | longitude | 181          |
      | portType  | Airport      |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Airport with Duplicate Airport Details
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | LLB              |
      | portName  | LLB Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port LLB Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | LLB              |
      | portName  | LLB Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the error "Duplicate Airport code. Airport code LLB is already exists" is displayed while creating new port

  @DeleteCreatedPorts
  Scenario: Add New Airport with existing Airport Details exclude Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GHG               |
      | portName  | Auto Test Airport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Airport           |
    And Verify the new port "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | QEL               |
      | portName  | Auto Test Airport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Airport           |
    And Verify the new airport "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Airport with Airport Code > 3 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJD         |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Airport with Airport Code < 3 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AA           |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Airport with Latitude <= 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | RPP          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Airport with Longitude <= 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | YHP          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | 180          |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
