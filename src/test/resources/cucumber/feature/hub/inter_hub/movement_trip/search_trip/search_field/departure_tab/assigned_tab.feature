@OperatorV2 @MiddleMile @Hub @InterHub @MovementTrip @SearchTrip @SearchField @DepartureTab @AssignedTab
Feature: Trip Management - Search Field - Departure Tab - Assigned Tab

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Destination Hub (uid:16123ee1-325d-4c88-959e-4d0200284ac6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "destination_hub"
    Then Operator verifies that the trip management shown with "destination_hub" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Trip ID (uid:1213b7a3-e898-4d23-ac5a-874bf6d094ee)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Movement Type (uid:e1cbce83-f057-4c8f-9b5f-c7f58fec21e1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Expected Departure Time (uid:a403748d-4656-40e7-a826-2882fa76663f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Arrival Time (uid:86d46d08-f937-4c9b-a98e-ae5ca423bac6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Driver (uid:9cf00b01-0d91-46cb-b994-428957439a03)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: Search Trip on Search Field - Departure Tab - Assigned Tab - Search Status (uid:4467d634-3a90-4981-b610-2ae44669ab47)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Trips
    And Operator verifies movement Trip page is loaded
    When Operator searches and selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op