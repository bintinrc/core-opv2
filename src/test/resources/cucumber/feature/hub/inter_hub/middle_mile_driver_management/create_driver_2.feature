@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileDrivers @CreateDriver2
Feature: Middle Mile Driver Management - Create Driver 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is B
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | B                              |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is B1
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | B1                             |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is B2
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | B2                             |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is C
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | C                              |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is Restriction 1
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | Restriction 1                  |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is Restriction 2
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | Restriction 2                  |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is Restriction 3
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | Restriction 3                  |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  @DeleteDriverV2
  Scenario: Create Driver - PH - License Type is all types
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | all types                      |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    When Operator clicks "Save to Create" button on Middle Mile Drivers Page
    Then Operator verifies that the new Middle Mile Driver has been created

  Scenario: Create Driver - PH - License Type is not selected
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator change the country to "Philippines"
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
      | licenseType    | Restriction 3                  |
      | employmentType | {default-employment-type-full} |
      | username       | RANDOM                         |
      | password       | {ninja-driver-password}        |
      | comments       | Created by Automation          |
    And Operator unchecks license type on Middle Mile Drivers Page
    Then Operator verifies "License Type" error message is shown on Middle Mile Drivers Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op