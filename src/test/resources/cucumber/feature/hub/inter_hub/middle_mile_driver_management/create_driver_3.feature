@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @CreateDriver3
Feature: Middle Mile Driver Management - Create Driver 3

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteMiddleMileDriver
  Scenario: Create Driver with Employment Type : In-House - Full-Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Singapore"
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    When Operator clicks "Add Driver" button on Middle Mile Drivers Page
    And Operator creates new Middle Mile Driver using below data:
      | firstName      | RANDOM                         |
      | lastName       | RANDOM                         |
      | displayName    | RANDOM                         |
      | hub            | {local-station-1-name}         |
      | contactNumber  | {default-phone-number-ph}      |
      | licenseNumber  | NV 1234                        |
      | licenseType    | {default-license-type-sg}      |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies Middle Mile Driver with username {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} has been created

  @DeleteMiddleMileDriver
  Scenario: Create Driver with Employment Type : In-House - Part-Time
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    When Operator clicks "Add Driver" button on Middle Mile Drivers Page
    And Operator creates new Middle Mile Driver using below data:
      | firstName      | RANDOM                    |
      | lastName       | RANDOM                    |
      | displayName    | RANDOM                    |
      | hub            | {local-station-1-name}    |
      | contactNumber  | {default-phone-number-ph} |
      | licenseNumber  | NV 1234                   |
      | licenseType    | {default-license-type-sg} |
      | employmentType | In-House - Part-Time      |
      | username       | RANDOM                    |
      | password       | {ninja-driver-password}   |
      | comments       | Created by Automation     |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies Middle Mile Driver with username {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} has been created

  @DeleteMiddleMileDriver
  Scenario: Create Driver with Employment Type : Outsourced - Subcon
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    When Operator clicks "Add Driver" button on Middle Mile Drivers Page
    And Operator creates new Middle Mile Driver using below data:
      | firstName      | RANDOM                    |
      | lastName       | RANDOM                    |
      | displayName    | RANDOM                    |
      | hub            | {local-station-1-name}    |
      | contactNumber  | {default-phone-number-ph} |
      | licenseNumber  | NV 1234                   |
      | licenseType    | {default-license-type-sg} |
      | employmentType | Outsourced - Subcon       |
      | username       | RANDOM                    |
      | password       | {ninja-driver-password}   |
      | comments       | Created by Automation     |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies Middle Mile Driver with username {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} has been created

  @DeleteMiddleMileDriver
  Scenario: Create Driver with Employment Type : Outsourced - Vendors
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    When Operator clicks "Add Driver" button on Middle Mile Drivers Page
    And Operator creates new Middle Mile Driver using below data:
      | firstName      | RANDOM                          |
      | lastName       | RANDOM                          |
      | displayName    | RANDOM                          |
      | hub            | {local-station-1-name}          |
      | contactNumber  | {default-phone-number-ph}       |
      | licenseNumber  | NV 1234                         |
      | licenseType    | {default-license-type-sg}       |
      | employmentType | Outsourced - Vendors            |
      | vendorName     | {default-driver-vendor-name-sg} |
      | username       | RANDOM                          |
      | password       | {ninja-driver-password}         |
      | comments       | Created by Automation           |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies Middle Mile Driver with username {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} has been created

  @DeleteMiddleMileDriver
  Scenario: Create Driver with Employment Type : Outsourced - Manpower Agency
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    When Operator clicks "Add Driver" button on Middle Mile Drivers Page
    And Operator creates new Middle Mile Driver using below data:
      | firstName      | RANDOM                              |
      | lastName       | RANDOM                              |
      | displayName    | RANDOM                              |
      | hub            | {local-station-1-name}              |
      | contactNumber  | {default-phone-number-ph}           |
      | licenseNumber  | NV 1234                             |
      | licenseType    | {default-license-type-sg}           |
      | employmentType | Outsourced - Manpower Agency        |
      | vendorName     | {default-driver-manpower-agency-sg} |
      | username       | RANDOM                              |
      | password       | {ninja-driver-password}             |
      | comments       | Created by Automation               |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies Middle Mile Driver with username {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} has been created

  @DeleteMiddleMileDriver
  Scenario: Create Driver with Display Name contains either Letters, Numbers, Hyphens, Underscores, and Parentheses
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Drivers
    When Operator refresh Middle Mile Driver Page
    And Operator verifies middle mile driver management page is loaded
    When Operator clicks "Add Driver" button on Middle Mile Drivers Page
    And Operator creates new Middle Mile Driver using below data:
      | firstName      | RANDOM                         |
      | lastName       | RANDOM                         |
      | displayName    | RANDOM-CUSTOM                  |
      | hub            | {local-station-1-name}         |
      | contactNumber  | {default-phone-number-ph}      |
      | licenseNumber  | NV 1234                        |
      | licenseType    | {default-license-type-sg}      |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies Middle Mile Driver with username {KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1].username} has been created

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op