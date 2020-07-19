@TripManagement @InterHub @MiddleMile @CWF
Feature: Trip Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  # Departure Tab - All Tab

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Destination Hub (uid:4a19b3bc-90b5-4998-88b5-9ecdfb49e949)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "destination_hub"
    Then Operator verifies that the trip management shown with "destination_hub" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Trip ID (uid:912f1784-b806-48a3-89ca-b6eddbcf46cd)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Movement Type (uid:7d05b6a3-6705-4474-a7d6-5dbfcfb27df8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Expected Departure Time (uid:4bbede02-cb82-42a6-8fb2-f7952b6381d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Arrival Time (uid:b9f42449-6966-45ed-8e12-e1642a27acd2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Driver (uid:890a7036-c4ee-4618-9334-41f7eb36bda1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - All Tab - Search Status (uid:f6271825-af18-496e-a069-62a65101f6b1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "All" tab
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  # Departure Tab - Unassigned Tab

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Destination Hub (uid:aaed2dde-8c72-46e8-bc16-d21f279e68cb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "destination_hub"
    Then Operator verifies that the trip management shown with "destination_hub" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Trip ID (uid:bdc99d60-24dc-4bee-a2d7-6fbe66edbb10)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Movement Type (uid:efefd7dd-4955-41f0-bf89-d24b9cca5aed)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Expected Departure Time (uid:42b610e9-a2ad-41cb-8433-20eec3472a04)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Arrival Time (uid:485b0c27-b837-494f-8a82-f71d8e5ca02d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Driver (uid:f7aaa48b-9ea9-4ed2-b00c-5fd9df8ae7ff)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Unassigned Tab - Search Status (uid:ddd6bfd7-1843-4f1a-b68c-5942582f263e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Unassigned" tab
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  # Departure Tab - Assigned Tab

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Destination Hub (uid:fa67ece1-0fb6-44f2-b2da-f65d381265d5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "destination_hub"
    Then Operator verifies that the trip management shown with "destination_hub" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Trip ID (uid:42f7a201-f949-4d4c-bbd8-eba36866a400)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Movement Type (uid:46a2af02-1407-44d2-a29f-b4e92ee9cf88)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Expected Departure Time (uid:5d1c5373-a5f7-4441-b634-ae945539cf22)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Arrival Time (uid:fc710de4-74f4-49ba-9110-2d8867f2ebbe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Driver (uid:892162a1-20f7-4122-9dc2-3c5f2ddf83d2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: OP Search Trip on Search Field - Departure Tab - Assigned Tab - Search Status (uid:82c6ebd4-4a9a-41f7-bcad-c65407a5e743)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator clicks on "Assigned" tab
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  # Arrival Tab

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Origin Hub (uid:1f0c330c-8c22-4f12-9213-fabfd414eb7f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "origin_hub"
    Then Operator verifies that the trip management shown with "origin_hub" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Trip ID (uid:12e1714f-6725-46ea-98d1-414600139571)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Movement Type (uid:69c87465-c2f1-4373-8e6d-caf834a2c82c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Expected Departure Time (uid:f3e0bd64-f6a8-4b96-ba3b-472eb4d33fe2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Actual Departure Time (uid:707ae922-20db-4bf4-a4bb-fac6ec7b45d7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "actual_departure_time"
    Then Operator verifies that the trip management shown with "actual_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Expected Arrival Time (uid:137e9800-1f61-4845-962a-a2917c671e2f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Driver (uid:e1d92ab4-c5c0-459b-947e-933fd4f39fd3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: OP Search Trip on Search Field - Arrival Tab - Search Status (uid:0f0c0dde-7bc5-4b0b-8a5f-418fd7e5119f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  # Archived Tab

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Origin Hub (uid:a2a9183e-f08f-414a-8422-f29b27744cdc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "origin_hub"
    Then Operator verifies that the trip management shown with "origin_hub" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Destination Hub (uid:3c2922fe-2c2b-4e7e-bc9b-41f1dc97ae4e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "destination_hub"
    Then Operator verifies that the trip management shown with "destination_hub" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Trip ID (uid:5f26570e-f90b-4959-9126-ea77b5eb7040)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "trip_id"
    Then Operator verifies that the trip management shown with "trip_id" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Movement Type (uid:88133a1a-b0e7-4524-8f62-9f51c4ecc2d0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "movement_type"
    Then Operator verifies that the trip management shown with "movement_type" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Expected Departure Time (uid:67c1b89e-fca3-47eb-8ef5-8d4872be5ef8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "expected_departure_time"
    Then Operator verifies that the trip management shown with "expected_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Actual Departure Time (uid:a4770681-3e30-420f-a3b5-a6fa86062236)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "actual_departure_time"
    Then Operator verifies that the trip management shown with "actual_departure_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Expected Arrival Time (uid:6f739d2e-982a-44b2-adb3-276923f3de95)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "expected_arrival_time"
    Then Operator verifies that the trip management shown with "expected_arrival_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Actual Arrival Time (uid:8db57f5f-6931-4eaa-bb89-05437d912bf5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "actual_arrival_time"
    Then Operator verifies that the trip management shown with "actual_arrival_time" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Driver (uid:beeadbb9-4b6a-47dd-9db7-24e34a6eac6b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "driver"
    Then Operator verifies that the trip management shown with "driver" as its filter is right

  Scenario: OP Search Trip on Search Field - Archived Tab - Search Status (uid:8d88468c-b9ed-440d-b205-60ca8814cfab)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive |
      | days             | 0       |
      | hubId            | 0       |
    And Operator searches for the Trip Management based on its "status"
    Then Operator verifies that the trip management shown with "status" as its filter is right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
