@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @SearchTrip @Filter @DepartureTab
Feature: Movement Trip - Search Trip - Filter - Departure Tab

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load Trip Use Filter - Departure Tab - No filter (uid:9b2117b6-6e7d-4f18-85af-8418e4643cbc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub (uid:196c24d0-ef86-4155-be1e-1b1893230f09)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Movement Type (uid:af28fa18-2531-4b2f-b032-8116ec506810)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Departure Date (uid:a1e3ad45-d6e2-4ac7-902e-a2b0dd99af68)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub and Movement Type (uid:539095f7-01d6-4997-b147-55bf52897f27)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub and Departure Date (uid:07d07c97-19e8-4a7c-b4d5-ba3f33f43ac2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub, Movement Type, and Departure Date (uid:f215de60-efdd-46e6-80fb-0a9fb6132b93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op