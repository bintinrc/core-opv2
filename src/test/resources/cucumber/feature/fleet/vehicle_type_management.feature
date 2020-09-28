@OperatorV2 @Fleet @OperatorV2Part1 @VehicleTypeManagement @Saas
Feature: Vehicle Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteVehicleTypes
  Scenario: Create New Vehicle Type (uid:f1d38bb4-2784-4a9d-a80c-2f21b498115a)
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    And API Operator gets data of created Vehicle Type
    Then Operator verify vehicle type

  @DeleteVehicleTypes
  Scenario: Seach Vehicle Type (uid:c91965a9-5955-4841-9949-096611ce65a9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    And API Operator gets data of created Vehicle Type
    Then Operator verify vehicle type

  @DeleteVehicleTypes
  Scenario: Update Vehicle Type (uid:1764c756-7439-4546-9990-d1ad7a3b1318)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    And API Operator gets data of created Vehicle Type
    When Operator edit the vehicle type name
    Then Operator verify the edited vehicle type name is existed

  @DeleteVehicleTypes
  Scenario: Delete Vehicle Type (uid:61c59793-5b5c-4f43-ac10-ac294b0c8977)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    And API Operator gets data of created Vehicle Type
    When Operator delete the vehicle type name
    Then Operator verify vehicle type name is deleted

  @DeleteVehicleTypes
  Scenario: Download CSV File of Vehicle Type (uid:4bbcbebc-4848-4105-bf78-321ada1ddbe1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Vehicle Type Management
    When Operator create new Vehicle Type
    And API Operator gets data of created Vehicle Type
    When Operator click on download CSV file button
    Then Operator verify the CSV file

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
