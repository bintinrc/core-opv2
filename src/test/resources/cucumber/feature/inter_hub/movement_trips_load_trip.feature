@TripManagement @InterHub @MiddleMile
Feature: Trip Management - Load Trips

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load Trip Use Filter - Departure Tab - No filter (uid:9b2117b6-6e7d-4f18-85af-8418e4643cbc)
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub (uid:196c24d0-ef86-4155-be1e-1b1893230f09)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Movement Type (uid:af28fa18-2531-4b2f-b032-8116ec506810)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Departure Date (uid:a1e3ad45-d6e2-4ac7-902e-a2b0dd99af68)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub and Movement Type (uid:539095f7-01d6-4997-b147-55bf52897f27)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub and Departure Date (uid:07d07c97-19e8-4a7c-b4d5-ba3f33f43ac2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Departure Tab - Filter by Origin Hub, Movement Type, and Departure Date (uid:f215de60-efdd-46e6-80fb-0a9fb6132b93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - No filter (uid:a55505ea-f602-46ac-a100-8c3fb13807d6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub (uid:871871f1-adec-4f77-a624-fa363563fc80)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Movement Type (uid:fd9cd117-58b3-49a1-9ed7-12c826fa174e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Arrival Date (uid:d9d8c18b-d3f5-47f3-ad14-ba6a5a7f04a6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub and Movement Type (uid:a0b93012-bcc9-4c9e-b3df-3d8baa1bfbe0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub and Arrival Date (uid:49d374f3-d309-4d1d-b988-c0f6c5514fb6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Arrival Tab - Filter by Destination Hub, Movement Type, Arrival Date (uid:7bf46e74-836d-4a9c-bebc-b18333c402ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: Load Trip Use Filter - Archived Tab - Load Without Filter (uid:63a089f2-1abc-4d1d-accd-6478898ddd42)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: Load Trip Use Filter - Archived Tab - Filter by Departure Date (uid:a67900c7-23df-466a-b4f2-3395ddd6b3c7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the date to 3 days early in "archive_departure_date" filter
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_departure_date |
      | days             | 3                      |
      | hubId            | 0                      |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: Load Trip Use Filter - Archived Tab - Filter by Arrival Date (uid:35674652-2322-4761-8130-3535c2bb6a69)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the date to 3 days early in "archive_arrival_date" filter
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_arrival_date |
      | days             | 3                    |
      | hubId            | 0                    |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: Load Trip Use Filter - Archived Tab - Filter by Origin Hub (uid:77f201f3-3b12-4645-a846-5af6fe96f745)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_origin_hub           |
      | days             | 0                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: Load Trip Use Filter - Archived Tab - Filter by Destination Hub (uid:c3f0b2df-a748-4d9c-be24-26f88f03b467)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_destination_hub      |
      | days             | 0                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: Load Trip Use Filter - Archived Tab - Filter by All (uid:d1366c11-5a4c-447e-a555-3eb69fc4a097)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the date to 3 days early in "archive_departure_date" filter
    When Operator selects the date to 3 days early in "archive_arrival_date" filter
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_all                  |
      | days             | 3                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
