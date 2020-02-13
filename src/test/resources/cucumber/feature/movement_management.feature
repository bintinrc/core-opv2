@OperatorV2 @OperatorV2Part2 @MovementManagement
Feature: Movement Management

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveAndDeleteHubViaDb
  Scenario: Operator should be able to create a new Hub on page Hubs Administration (uid:c753d5ed-1026-408e-9c71-0e5b8f4e7aa3)
    Given Operator go to menu Hubs -> Facilities Management
    When Operator create new Hub on page Hubs Administration using data below:
      | name        | GENERATED     |
      | displayName | GENERATED     |
      | type        | Crossdock Hub |
      | city        | GENERATED     |
      | country     | GENERATED     |
      | latitude    | GENERATED     |
      | longitude   | GENERATED     |
    Then Operator verify a new Hub is created successfully on page Hubs Administration
    When Operator go to menu Inter-Hub -> Movement Management
    When Movement Management page is loaded
    Then Operator can select "{KEY_HUBS_ADMINISTRATION.name}" crossdock hub when create crossdock movement schedule

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
