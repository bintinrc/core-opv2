@OperatorV2 @VehicleTypeManagement @Current
Feature: Vehicle Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create new vehicle type (uid:2926a8ff-45f5-4df2-b04d-efc5bab48796)
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then verify vehicle type
    When operator delete the vehicle type name
    Then operator verify vehicle type name is deleted

  Scenario: Operator search vehicle type (uid:71753ae9-ac12-4d17-917c-6c5bad435d66)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then verify vehicle type
    When operator delete the vehicle type name
    Then operator verify vehicle type name is deleted

  Scenario: Operator edit vehicle type (uid:6687b26f-84ad-4e0f-bc46-a84a54b0c156)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then verify vehicle type
    When operator edit the vehicle type name
    Then verify the edited vehicle type name is existed
    When operator delete the vehicle type name
    Then operator verify vehicle type name is deleted

  Scenario: Operator delete vehicle type (uid:ca337865-701b-4573-b5bc-643cc68724fb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then verify vehicle type
    When operator delete the vehicle type name
    Then operator verify vehicle type name is deleted

  Scenario: Operator download and verify CSV file of vehicle type on Vehicle Type Management page (uid:c8156f4a-07c7-4cb2-821e-3ba3a9ea962b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    Then verify vehicle type
    When operator click on download CSV file button
    Then verify the csv file
    When operator delete the vehicle type name
    Then operator verify vehicle type name is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
