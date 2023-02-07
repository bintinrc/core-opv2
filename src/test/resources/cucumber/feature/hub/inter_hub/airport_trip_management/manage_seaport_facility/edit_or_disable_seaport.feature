@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @EditDisableSeaport
Feature: Port Trip Management - Edit/Disable Seaport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with Seaport Code 5 numbers
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | PLUQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | 12345 |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with Seaport Code 5 letters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | BNGQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | RQMQQ |
    And Verify the new port "Port Test Seaport has been updated" created success message

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with Seaport Code 5 mix letter and number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | AOZQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | 12AQQ |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form
    And Verify the newly created port values in table

  @DeleteCreatedPorts
  Scenario: Edit Full Seaport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | MBNQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portName" for created Port
      | portName | Auto Seaport |
    And Verify the new port "Port Auto Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport's City
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | RCEQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "city" for created Port
      | city | Singapore |
    And Verify the new port "Port Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Region
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OPPQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "region" for created Port
      | region | GW |
    And Verify the new port "Port Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Latitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | IWXQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "latitude" for created Port
      | latitude | 11 |
    And Verify the new port "Port Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Longitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ULOQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "longitude" for created Port
      | longitude | -80 |
    And Verify the new port "Port Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with < 5 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OSGQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | Z |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with > 5 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ZBSQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | MegaQQ |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with 5 mix letter and number
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | GQGQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | 12AQQ |
    And Verify the validation error "Seaport code must be exactly 5 letters" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with existing Seaport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | UQXQQ            |
      | portName  | UQXQQ Test Seaport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 37.9220427       |
      | longitude | -81.6894072      |
      | portType  | Seaport          |
    And Verify the new port "Port UQXQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | SQXQQ            |
      | portName  | SQXQQ Test Seaport |
      | city      | SG               |
      | region    | JKB              |
      | latitude  | 36.9220427       |
      | longitude | -80.6894072      |
      | portType  | Seaport          |
    And Verify the new port "Port SQXQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | UQXQQ |
    And Verify the error "Duplicate Seaport code. Seaport code UQXQQ is already exists" is displayed while creating new port

  @DeleteCreatedPorts
  Scenario: Edit Full Seaport Name with existing Seaport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | JIQQQ              |
      | portName  | JIQQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port JIQQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    Then Operator Add new Port
      | portCode  | IUZQQ              |
      | portName  | IUZQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 36.9220427         |
      | longitude | -80.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port IUZQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portName" for created Port
      | portName | JIQQQ Test Seaport |
    And Verify the new port "Port JIQQQ Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport Code with same Seaport Code value
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | DZZQQ              |
      | portName  | DZZQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port DZZQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portCode" for created Port
      | portCode | DZZQQ |
    And Verify the new port "Port DZZQQ Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Latitude with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | BKAQQ              |
      | portName  | BKAQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port BKAQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "latitude" for created Port
      | latitude | 91 |
    And Verify the validation error "Latitude must be maximum 90" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Longitude with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | BQYQQ              |
      | portName  | BQYQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port BQYQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "longitude" for created Port
      | longitude | 181 |
    And Verify the validation error "Longitude must be maximum 180" is displayed in Add New Port form

  @DeleteCreatedPorts
  Scenario: Disable Seaport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | ITGQQ              |
      | portName  | ITGQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port ITGQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts
  Scenario: Activate Seaport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | XUBQQ              |
      | portName  | XUBQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port ACJQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Activate" button on panel on Port Trip Management page
    And Verify the new port "Port successfully enabled" created success message
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts
  Scenario: Cancel Disable Seaport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | MPHQQ              |
      | portName  | MPHQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port MPHQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Disable" button

  @DeleteCreatedPorts
  Scenario: Cancel Activate Seaport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | KRGQQ              |
      | portName  | KRGQQ Test Seaport |
      | city      | SG                 |
      | region    | JKB                |
      | latitude  | 37.9220427         |
      | longitude | -81.6894072        |
      | portType  | Seaport            |
    And Verify the new port "Port KRGQQ Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Operator click on Disable button for the created Port in table
    And Click on "Disable" button on panel on Port Trip Management page
    And Verify the new port "Port successfully disabled" created success message
    And Operator click on Activate button for the created Port in table
    And Click on "Cancel" button on panel on Port Trip Management page
    And Verify the port is displayed with "Activate" button

  @DeleteCreatedPorts
  Scenario: Edit Seaport Port Type
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | OOAQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 37.9220427   |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "portType" for created Port
      | portType | Seaport |

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Latitude with Latitude <= 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | MTMQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | -81.6894072  |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "latitude" for created Port
      | latitude | 90 |
    And Verify the new port "Port Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @DeleteCreatedPorts
  Scenario: Edit Seaport's Longitude with Longitude <= 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Port Trip Management
    Given Operator refresh page v1
    And API Operator refresh "Seaport" cache
    And Operator verifies that the Port Management Page is opened
    When Operator click on Manage Port Facility and verify all components
    Then Operator Add new Port
      | portCode  | NNMQQ        |
      | portName  | Test Seaport |
      | city      | SG           |
      | region    | JKB          |
      | latitude  | 90           |
      | longitude | 180          |
      | portType  | Seaport      |
    And Verify the new port "Port Test Seaport has been created" created success message
    And Verify the newly created port values in table
    And Edit the "longitude" for created Port
      | longitude | 180 |
    And Verify the new port "Port Test Seaport has been updated" created success message
    And Verify the newly updated port values in table

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
