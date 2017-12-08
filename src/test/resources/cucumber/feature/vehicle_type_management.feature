@OperatorV2 @VehicleTypeManagement @ShouldAlwaysRun
Feature: Vehicle type management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: add vehicle type (uid:2926a8ff-45f5-4df2-b04d-efc5bab48796)
    Given Operator go to menu Fleet -> Vehicle Type Management
    When vehicle type management, add vehicle type button is clicked
    When vehicle type management, add new vehicle type of "QA"
    Then vehicle type management, verify new vehicle type "QA" existed

  Scenario: search vehicle type (uid:71753ae9-ac12-4d17-917c-6c5bad435d66)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When vehicle type management, search for "QA" vehicle type
    Then vehicle type management, verify vehicle type "QA" existed

  Scenario: edit vehicle type (uid:6687b26f-84ad-4e0f-bc46-a84a54b0c156)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When vehicle type management, search for "QA" vehicle type
    When vehicle type management, edit vehicle type of "QA"
    Then vehicle type management, verify vehicle type "QA [EDITED]" existed

  Scenario: delete vehicle type (uid:ca337865-701b-4573-b5bc-643cc68724fb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When vehicle type management, search for "QA [EDITED]" vehicle type
    When vehicle type management, delete vechile type
    Then vehicle type management, verify vehicle type "QA [EDITED]" not existed

  @KillBrowser
  Scenario: Kill Browser
