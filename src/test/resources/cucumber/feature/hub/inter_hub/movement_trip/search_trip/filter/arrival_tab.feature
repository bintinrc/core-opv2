@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @SearchTrip @Filter @ArrivalTab
Feature: Trip Management - Filter - Arrival Tab

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load Trip Use Filter - Arrival Tab - No filter (uid:a55505ea-f602-46ac-a100-8c3fb13807d6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub (uid:871871f1-adec-4f77-a624-fa363563fc80)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Movement Type (uid:fd9cd117-58b3-49a1-9ed7-12c826fa174e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Arrival Date (uid:d9d8c18b-d3f5-47f3-ad14-ba6a5a7f04a6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub and Movement Type (uid:a0b93012-bcc9-4c9e-b3df-3d8baa1bfbe0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub and Arrival Date (uid:49d374f3-d309-4d1d-b988-c0f6c5514fb6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub, Movement Type, Arrival Date (uid:7bf46e74-836d-4a9c-bebc-b18333c402ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op