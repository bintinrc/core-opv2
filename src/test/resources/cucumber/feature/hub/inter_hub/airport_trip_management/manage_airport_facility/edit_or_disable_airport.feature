@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditDisableAirport
Feature: Port Trip Management - Edit/Disable Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Edit Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | PLU          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | BNG |
    And Verify the new port "Port Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Full Airport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | RQM          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portName" for created Port
      | portName | Auto Airport |
    And Verify the new port "Port Auto Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport's City
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AOZ          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "city" for created Port
      | city | Singapore |
    And Verify the new port "Port Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport's Region
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | MBN          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "region" for created Port
      | region | GW |
    And Verify the new port "Port Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport's Latitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | RCE          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "latitude" for created Port
      | latitude | 11 |
    And Verify the new port "Port Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport's Longitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OPP          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "longitude" for created Port
      | longitude | -80 |
    And Verify the new port "Port Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport Code with < 3 letters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | IWX          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | Z |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Airport Code with > 3 letters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ULO          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | Mega |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Airport Code with 3 mix letter and number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OSG          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | 12A |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Airport Code with existing Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ZBS              |
      | portName  | ZBS Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port ZBS Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | GQG              |
      | portName  | GQG Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 36.9220427       |
      | longitude | -80.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port GQG Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | ZBS |
    And Verify the error "Duplicate Airport code. Airport code AAJ is already exists" is displayed while creating new port

  @DeleteCreatedPorts
  Scenario: Edit Full Airport Name with existing Airport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | UQX              |
      | portName  | UQX Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port UQX Test Airport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | SQX              |
      | portName  | SQX Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 36.9220427       |
      | longitude | -80.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port SQX Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portName" for created Port
      | portName | UQX Test Airport |
    And Verify the new port "Port UQX Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport Code with same Airport Code value
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | JIQ              |
      | portName  | JIQ Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port JIQ Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | JIQ |
    And Verify the new port "Port JIQ Test Airport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Airport's Latitude with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | IUZ              |
      | portName  | IUZ Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port IUZ Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "latitude" for created Port
      | latitude | 91 |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Airport's Longitude with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | DZZ              |
      | portName  | DZZ Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port DZZ Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "longitude" for created Port
      | longitude | 181 |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Disable Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | BKA              |
      | portName  | BKA Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port BKA Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts
  Scenario: Activate Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | BQY              |
      | portName  | BQY Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port BQY Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Activate" button on panel on Port Trip Management page
    And Verify the new port "Port successfully enabled" created success message
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts
  Scenario: Cancel Disable Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ITG              |
      | portName  | ITG Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port ITG Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts
  Scenario: Cancel Activate Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | XUB              |
      | portName  | XUB Test Airport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Airport          |
    And Verify the new port "Port XUB Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts
  Scenario: Edit Airport Port Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh Airports cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | MPH          |
      | portName  | Test Airport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Airport      |
    And Verify the new port "Port Test Airport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portType" for created Port
      | portType | Seaport |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
