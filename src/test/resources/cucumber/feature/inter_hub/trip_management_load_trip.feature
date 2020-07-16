@TripManagement @InterHub @MiddleMile
Feature: Trip Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: OP Load Trip Use Filter - Departure Tab - No filter (uid:e8bf8cfa-7b50-415a-a92f-8869228cc61c)
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: OP Load Trip Use Filter - Departure Tab - Filter by Origin Hub (uid:1bd3482f-2700-49b9-bf33-3fafe69071ca)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: OP Load Trip Use Filter - Departure Tab - Filter by Movement Type (uid:ee941c02-5f85-4975-a341-d51f426dc90f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: OP Load Trip Use Filter - Departure Tab - Filter by Departure Date (uid:fa61fb73-e85d-4701-8d72-a29be08170a6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: OP Load Trip Use Filter - Departure Tab - Filter by Origin Hub and Movement Type (uid:19ad4d0b-fc7b-4234-ad30-d805ec88fa8c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: OP Load Trip Use Filter - Departure Tab - Filter by Origin Hub and Departure Date (uid:1a3b3e8f-7705-433b-993a-b4ccd043bb24)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: OP Load Trip Use Filter - Departure Tab - Filter by Origin Hub, Movement Type, Departure Date (uid:2721809b-03e0-406b-82c8-32a932559804)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    When Operator selects the date to tomorrow in "departure" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "departure" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "departure" tab is correct

  Scenario: OP Load Trip Use Filter - Arrival Tab - No filter (uid:21378eea-3e11-4cd7-a2ba-d9d7d55f1de6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: OP Load Trip Use Filter - Arrival Tab - Filter by Destination Hub (uid:a72b9fdf-acb1-4c00-b180-195446df4b47)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: OP Load Trip Use Filter - Arrival Tab - Filter by Movement Type (uid:9f746015-b17d-44b2-93c8-a6047ffa2dc0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: OP Load Trip Use Filter - Arrival Tab - Filter by Arrival Date (uid:dcc75baa-d499-49fd-bded-9e8ce9b628bf)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    Then Operator verifies that there will be an error shown for unselected Origin Hub

  Scenario: OP Load Trip Use Filter - Arrival Tab - Filter by Destination Hub and Movement Type (uid:2da67b5f-f8eb-44aa-81ef-9851bff417fe)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: OP Load Trip Use Filter - Arrival Tab - Filter by Destination Hub and Arrival Date (uid:14e8b043-0ded-4926-a2c4-4e0d11e02ad3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: OP Load Trip Use Filter - Arrival Tab - Filter by Destination Hub, Movement Type, Arrival Date (uid:d0d3674c-6f9f-4f6f-a461-dde20a7811c4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Arrival" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    When Operator selects the "movement type" with value "Land Haul"
    When Operator selects the date to tomorrow in "arrival" Tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the "arrival" Trip Management based on the hub id = "{hub-relation-origin-hub-id}"
    Then Operator verifies that the trip management shown in "arrival" tab is correct

  Scenario: OP Load Trip Use Filter - Archived Tab - Load Without Filter (uid:0c2d0439-4eb6-482f-855b-c06d52c87d63)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | none |
      | days             | 0    |
      | hubId            | null |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: OP Load Trip Use Filter - Archived Tab - Filter by Departure Date (uid:4316f393-f493-4d3b-8d00-2cc48bf747d9)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the date to 3 days early in "archive_departure_date" filter
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_departure_date |
      | days             | 3                      |
      | hubId            | null                   |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: OP Load Trip Use Filter - Archived Tab - Filter by Arrival Date (uid:21ec224c-e09c-4641-8574-5835ca096c71)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the date to 3 days early in "archive_arrival_date" filter
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_arrival_date |
      | days             | 3                    |
      | hubId            | null                 |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: OP Load Trip Use Filter - Archived Tab - Filter by Origin Hub (uid:cebcb18a-5725-46d2-8a7f-53e921764505)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the "origin hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_origin_hub           |
      | days             | 0                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: OP Load Trip Use Filter - Archived Tab - Filter by Destination Hub (uid:08d6da41-1782-4e65-91de-127cf92a6a94)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
    And Operator verifies that the Trip Management Page is opened
    When Operator clicks on "Archive" tab
    When Operator selects the "destination hub" with value "{hub-relation-origin-hub-name}"
    And Operator clicks on Load Trip Button
    And API Operator gets the count of the Trip Management with data:
      | movementTripType | archive_destination_hub      |
      | days             | 0                            |
      | hubId            | {hub-relation-origin-hub-id} |
    Then Operator verifies that the archived trip management is shown correctly

  Scenario: OP Load Trip Use Filter - Archived Tab - Filter by All (uid:e156b25b-3287-463c-8383-79041eabbcb7)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator goes to Trip Management Page
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
