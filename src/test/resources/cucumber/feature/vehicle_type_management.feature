@OperatorV2 @OperatorV2Part1 @VehicleTypeManagement @Saas
Feature: Vehicle Type Management

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create new vehicle type (uid:2926a8ff-45f5-4df2-b04d-efc5bab48796)
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then Operator verify vehicle type
    When Operator delete the vehicle type name
    Then Operator verify vehicle type name is deleted

  Scenario: Operator search vehicle type (uid:71753ae9-ac12-4d17-917c-6c5bad435d66)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then Operator verify vehicle type
    When Operator delete the vehicle type name
    Then Operator verify vehicle type name is deleted

  Scenario: Operator edit vehicle type (uid:6687b26f-84ad-4e0f-bc46-a84a54b0c156)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then Operator verify vehicle type
    When Operator edit the vehicle type name
    Then Operator verify the edited vehicle type name is existed
    When Operator delete the vehicle type name
    Then Operator verify vehicle type name is deleted

  Scenario: Operator delete vehicle type (uid:ca337865-701b-4573-b5bc-643cc68724fb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then Operator verify vehicle type
    When Operator delete the vehicle type name
    Then Operator verify vehicle type name is deleted

  Scenario: Operator download and verify CSV file of vehicle type on Vehicle Type Management page (uid:c8156f4a-07c7-4cb2-821e-3ba3a9ea962b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then Operator verify vehicle type
    When Operator click on download CSV file button
    Then Operator verify the CSV file
    When Operator delete the vehicle type name
    Then Operator verify vehicle type name is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
