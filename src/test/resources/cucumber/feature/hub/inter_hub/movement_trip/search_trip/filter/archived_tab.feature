@TripManagement @InterHub @MiddleMile @Filter @ArchivedTab
Feature: Trip Management - Filter - Archived Tab

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load Trip Use Filter - Archived Tab - Load Without Filter (uid:63a089f2-1abc-4d1d-accd-6478898ddd42)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
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
    And Operator verifies movement Trip page is loaded
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
    And Operator verifies movement Trip page is loaded
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
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Archive" tab
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_origin_hub           |
      | days             | 0                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: Load Trip Use Filter - Archived Tab - Filter by Destination Hub (uid:c3f0b2df-a748-4d9c-be24-26f88f03b467)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
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
    And Operator verifies movement Trip page is loaded
    When Operator clicks on "Archive" tab
    When Operator selects the date to 3 days early in "archive_departure_date" filter
    When Operator selects the date to 3 days early in "archive_arrival_date" filter
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_all                  |
      | days             | 3                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op