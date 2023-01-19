@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AddNewAirport
Feature: Airport Trip Management - Add New Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with existing Port Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ABAQQ            |
      | portName  | ABA Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port ABA Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | ABAQQ            |
      | portName  | New Test Airport |
      | city      | Singapore        |
      | region    | GW               |
      | latitude  | 20.9220427       |
      | longitude | -11.6894072      |
      | portType  | Airport          |
    And Verify the error "Duplicate Airport code. Airport code ABA is already exists" is displayed while creating new port

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with existing Port Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OWOQQ             |
      | portName  | Auto Test Airport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Airport           |
    And Verify the new port "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | UWUQQ             |
      | portName  | Auto Test Airport |
      | city      | Singapore         |
      | region    | GW                |
      | latitude  | 20.9220427        |
      | longitude | -11.6894072       |
      | portType  | Airport           |
    And Verify the new port "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ADAQQ        |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 95.922       |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ADAQQ        |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 15.922       |
      | longitude | 181          |
      | portType  | Airport      |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with existing Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OWOQQ            |
      | portName  | OWO Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port OWO Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | OWOQQ            |
      | portName  | OWO Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the error "Duplicate Airport code. Airport code OWO is already exists" is displayed while creating new port

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with existing Airport Details exclude Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OWOQQ             |
      | portName  | Auto Test Airport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Airport           |
    And Verify the new port "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | UWUQQ             |
      | portName  | Auto Test Airport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Airport           |
    And Verify the new airport "Port Auto Test Airport has been created" created success message
    And Verify the newly created port values in table

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with Airport Code > 3 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
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

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with Airport Code < 3 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
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

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with Latitude <= 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJ          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table

  @ForceSuccessOrder @DeleteCreatedPorts
  Scenario: Add New Airport with Longitude <= 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Seaports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJ          |
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
