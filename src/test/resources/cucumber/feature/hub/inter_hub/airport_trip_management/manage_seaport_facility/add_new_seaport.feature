@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AddNewSeaport
Feature: Port Trip Management - Add New Seaport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Add New Seaport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
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

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Seaport Code 5 numbers
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | 12345        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Seaport Code 5 letters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
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

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Seaport Code 5 mix letter and number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | 12AB5        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Seaport Code > 5 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJD         |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Seaport Code < 5 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AA           |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Seaport with existing Seaport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ABAQQ            |
      | portName  | ABA Test Seaport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Seaport          |
    And Verify the new port "Port ABA Test Seaport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | ABAQQ            |
      | portName  | ABA Test Seaport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Seaport          |
    And Verify the error "Duplicate Seaport code. Seaport code ABAQQ is already exists" is displayed while creating new port

  @DeleteCreatedPorts
  Scenario: Add New Seaport with existing Seaport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ABAQQ            |
      | portName  | ABA Test Seaport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Seaport          |
    And Verify the new port "Port ABA Test Seaport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | ABAQQ            |
      | portName  | New Test Seaport |
      | city      | Singapore        |
      | region    | GW               |
      | latitude  | 20.9220427       |
      | longitude | -11.6894072      |
      | portType  | Seaport          |
    And Verify the error "Duplicate Seaport code. Seaport code ABAQQ is already exists" is displayed while creating new port

  @DeleteCreatedPorts
  Scenario: Add New Seaport with existing Seaport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OWOQQ             |
      | portName  | Auto Test Seaport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Seaport           |
    And Verify the new port "Port Auto Test Seaport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | UWUQQ             |
      | portName  | Auto Test Seaport |
      | city      | Singapore         |
      | region    | GW                |
      | latitude  | 20.9220427        |
      | longitude | -11.6894072       |
      | portType  | Seaport           |
    And Verify the new port "Port Auto Test Seaport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ADAQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 95.922       |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ADAQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 15.922       |
      | longitude | 181          |
      | portType  | Seaport      |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Add New Seaport with existing Seaport Details exclude Seaport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OWOQQ             |
      | portName  | Auto Test Seaport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Seaport           |
    And Verify the new port "Port Auto Test Seaport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | UWUQQ             |
      | portName  | Auto Test Seaport |
      | city      | SG                |
      | region    | JKB               |
      | latitude  | 37.9220427        |
      | longitude | -81.6894072       |
      | portType  | Seaport           |
    And Verify the new port "Port Auto Test Seaport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Latitude <= 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Add New Seaport with Longitude <= 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AAJQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | 180          |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
