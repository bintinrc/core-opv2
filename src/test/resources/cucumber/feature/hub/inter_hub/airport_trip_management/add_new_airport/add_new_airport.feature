@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @AddNewAirport
Feature: Airport Trip Management - Add New Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | AAJ             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"Test Airport\" has been created" created success message
    And Verify the newly created airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with existing Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ABA               |
      | airportName   | ABA Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"ABA Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    Then Operator Add new Airport
      | airportCode   | ABA               |
      | airportName   | New Test Airport  |
      | city          | Singapore         |
      | region        | GW                |
      | latitude      | 20.9220427        |
      | longitude     | -11.6894072       |
    And Capture the error in Airport Trip Management Page
    And Verify the error "Duplicate Airport code. Airport code ABA is already exists" is displayed while creating new airport

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with existing Airport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACB               |
      | airportName   | Auto Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"Auto Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    Then Operator Add new Airport
      | airportCode   | ACC               |
      | airportName   | Auto Test Airport |
      | city          | Singapore         |
      | region        | GW                |
      | latitude      | 20.9220427        |
      | longitude     | -11.6894072       |
    And Verify the new airport "Airport \"Auto Test Airport\" has been created" created success message
    And Verify the newly created airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ADA             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 95.922          |
      | longitude     | -81.6894072     |
    And Verify the validation error "Latitude must be maximum 90" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ADA             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 15.922          |
      | longitude     | 181             |
    And Verify the validation error "Longitude must be maximum 180" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with existing Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ABA               |
      | airportName   | ABA Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"ABA Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    Then Operator Add new Airport
      | airportCode   | ABA               |
      | airportName   | ABA Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Capture the error in Airport Trip Management Page
    And Verify the error "Duplicate Airport code. Airport code ABA is already exists" is displayed while creating new airport

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with existing Airport Details exclude Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | AEB               |
      | airportName   | Auto Test Airport |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"Auto Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    Then Operator Add new Airport
      | airportCode   | AEC               |
      | airportName   | Auto Test Airport |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"Auto Test Airport\" has been created" created success message
    And Verify the newly created airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Add New Airport with Airport Code > 3 characters
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | AAJD            |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
