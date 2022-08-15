@OperatorV2 @MiddleMile @Hub @InterHub @AirportTripManagement @EditDisableAirport @1
Feature: Airport Trip Management - Edit/Disable Airport

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code
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
    And Edit the "airportCode" for created Airport
      | airportCode   | AAK             |
    And Verify the new airport "Airport \"Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Full Airport Name
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
    And Edit the "airportName" for created Airport
      | airportName   | Auto Airport    |
    And Verify the new airport "Airport \"Auto Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport's City
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | BAJ             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "city" for created Airport
      | city   | Singapore    |
    And Verify the new airport "Airport \"Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport's Region
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | BAJ             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "region" for created Airport
      | region   | GW    |
    And Verify the new airport "Airport \"Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport's Latitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | BAJ             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "latitude" for created Airport
      | latitude   | 11    |
    And Verify the new airport "Airport \"Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport's Longitude
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | BAJ             |
      | airportName   | Test Airport    |
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "longitude" for created Airport
      | longitude   | -80    |
    And Verify the new airport "Airport \"Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code with < 3 letters
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
    And Edit the "airportCode" for created Airport
      | airportCode   | Z               |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code with > 3 letters
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
    And Edit the "airportCode" for created Airport
      | airportCode   | Mega             |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code with 3 mix letter and number
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
    And Edit the "airportCode" for created Airport
      | airportCode   | 12A             |
    And Verify the validation error "Airport code must be exactly 3 letters" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code with existing Airport Code
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | AAJ               |
      | airportName   | AAJ Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"AAJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    Then Operator Add new Airport
      | airportCode   | AAK               |
      | airportName   | AAK Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 36.9220427        |
      | longitude     | -80.6894072       |
    And Verify the new airport "Airport \"AAK Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "airportCode" for created Airport
      | airportCode   | AAJ             |
    And Capture the error in Airport Trip Management Page
    And Verify the error "Duplicate Airport code. Airport code AAJ is already exists" is displayed while creating new airport

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code with existing Airport Name
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ABJ               |
      | airportName   | ABJ Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"ABJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    Then Operator Add new Airport
      | airportCode   | ABK               |
      | airportName   | ABK Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 36.9220427        |
      | longitude     | -80.6894072       |
    And Verify the new airport "Airport \"ABK Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "airportName" for created Airport
      | airportName   | ABJ Test Airport  |
    And Verify the new airport "Airport \"ABJ Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport Code with same Airport Code value
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ABJ               |
      | airportName   | ABJ Test Airport  |
      | city          | SG                |
      | region        | JKB               |
      | latitude      | 37.9220427        |
      | longitude     | -81.6894072       |
    And Verify the new airport "Airport \"ABJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "airportCode" for created Airport
      | airportCode   | ABJ     |
    And Verify the new airport "Airport \"ABJ Test Airport\" has been updated" created success message
    And Verify the newly updated airport values in table

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport's Latitude with Latitude > 90
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACJ             |
      | airportName   | ACJ Test Airport|
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"ACJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "latitude" for created Airport
      | latitude    | 91             |
    And Verify the validation error "Latitude must be maximum 90" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Edit Airport's Longitude with Longitude > 180
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACJ             |
      | airportName   | ACJ Test Airport|
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"ACJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Edit the "longitude" for created Airport
      | longitude    | 181              |
    And Verify the validation error "Longitude must be maximum 180" is displayed

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Disable Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACJ             |
      | airportName   | ACJ Test Airport|
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"ACJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Operator click on Disable button for the created Airport in table
    And Click on "Disable" button on panel
    And Verify the new airport "Airport disabled successfully" created success message
    And Verify the airport is displayed with "Activate" button

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Activate Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACJ             |
      | airportName   | ACJ Test Airport|
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"ACJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Operator click on Disable button for the created Airport in table
    And Click on "Disable" button on panel
    And Verify the new airport "Airport disabled successfully" created success message
    And Operator click on Activate button for the created Airport in table
    And Click on "Activate" button on panel
    And Verify the new airport "Airport activated successfully" created success message
    And Verify the airport is displayed with "Disable" button

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Cancel Disable Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACL             |
      | airportName   | ACL Test Airport|
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"ACL Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Operator click on Disable button for the created Airport in table
    And Click on "Cancel" button on panel
    And Verify the airport is displayed with "Disable" button

  @ForceSuccessOrder @DeleteCreatedAirports
  Scenario: Cancel Activate Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Airport Trip Management
    And API Operator refresh Airports cache
    And Operator verifies that the Airport Management Page is opened
    When Operator click on Manage Airport Facility and verify all components
    Then Operator Add new Airport
      | airportCode   | ACJ             |
      | airportName   | ACJ Test Airport|
      | city          | SG              |
      | region        | JKB             |
      | latitude      | 37.9220427      |
      | longitude     | -81.6894072     |
    And Verify the new airport "Airport \"ACJ Test Airport\" has been created" created success message
    And Verify the newly created airport values in table
    And Operator click on Disable button for the created Airport in table
    And Click on "Disable" button on panel
    And Verify the new airport "Airport disabled successfully" created success message
    And Operator click on Activate button for the created Airport in table
    And Click on "Cancel" button on panel
    And Verify the airport is displayed with "Activate" button

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
