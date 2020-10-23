@Hub @InterHub @MiddleMile @TripManagement @MovementTrip @UpdateTrip
Feature: Movement Trip - Update Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Register Trip Departure (uid:0c81ca15-0dbe-43f8-b48a-e8f2572bc6d7)
    Given no-op

  Scenario: Register Trip Departure without Driver (uid:9af1c868-e9f5-4cf2-9b92-3c70c59d264c)
    Given no-op

  Scenario: Register Trip Departure with Invalid Driver Employment Status - Main Driver Employment Status is Inactive (uid:aaee95f2-c6ee-4054-aa56-132d0757a5cf)
    Given no-op

  Scenario: Register Trip Departure with Invalid Driver Employment Status - Additional Driver Employment Status is Inactive (uid:a9695379-6ce2-4c1b-926e-8409d24e9408)
    Given no-op

  Scenario: Register Trip Departure with Invalid Driver Employment Status - Main and Additional Driver Employment Status are Inactive (uid:20557fe2-72fd-4b8f-9d50-f563d9148972)
    Given no-op

  Scenario: Register Trip Departure With Invalid Driver License Status - Main Driver License Status is Inactive (uid:7c5bd44b-7fbd-4cc1-9699-acd274520c4e)
    Given no-op

  Scenario: Register Trip Departure With Invalid Driver License Status - Additional Driver License Status is Inactive (uid:074aaab5-7de0-486a-bf46-088611166c57)
    Given no-op

  Scenario: Register Trip Departure With Invalid Driver License Status - Main and additional Driver License Status are Inactive (uid:cb5134b9-c414-4793-a77d-92384d590cda)
    Given no-op

  Scenario: Register Trip Departure With Invalid Driver Employment and License Status - Main Driver Employment Status and License Status are Inactive (uid:b3677fa8-6905-4f1f-9d42-d0a4747a08ab)
    Given no-op

  Scenario: Register Trip Departure With Invalid Driver Employment and License Status - Additional Driver Employment Status and License Status are Inactive (uid:65913ea4-f97c-4269-91c1-a695ffb6f15b)
    Given no-op

  Scenario: Register Trip Departure With Invalid Driver Employment and License Status - Main and Additional Driver Employment Status and License Status are Inactive (uid:48ea8cc1-01f0-4d20-87ba-56fa8ee16862)
    Given no-op

  Scenario: Register Trip Arrival (uid:60b02a8a-555b-4282-a1d1-a8fbf76f550b)
    Given no-op

  Scenario: Register Trip Departure with Driver Still In Transit (uid:46df4679-d92c-4b16-b140-d8a3a28c3aa4)
    Given no-op

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op