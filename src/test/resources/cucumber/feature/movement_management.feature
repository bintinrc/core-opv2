@OperatorV2 @OperatorV2Part2 @MovementManagement
Feature: Movement Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
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
    And Operator opens Add Movement Schedule dialog on Movement Management page
    Then Operator can select "{KEY_HUBS_ADMINISTRATION.name}" crossdock hub when create crossdock movement schedule

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - apply all days - 1 movement scedule/day (uid:)
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
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_HUBS_ADMINISTRATION[1].name} |
      | destinationHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[2].name} |
      | applyToAllDays | true                                      |
      | startTime      | 15:15                                     |
      | duration       | 1                                         |
      | endTime        | 18 h 30 m                                 |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_HUBS_ADMINISTRATION[1].name} |
      | destinationHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - Origin Crossdock Hub same with Destination Crossdock Hub (uid:)
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
    And Movement Management page is loaded
    And Operator opens Add Movement Schedule dialog on Movement Management page
    And Operator fill Add Movement Schedule form using data below:
      | originHub | {KEY_HUBS_ADMINISTRATION.name} |
    Then Operator can not select "{KEY_HUBS_ADMINISTRATION.name}" destination crossdock hub on Add Movement Schedule dialog

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Cancel Create New Crossdock Movement Schedule (uid:)
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
    And Movement Management page is loaded
    And Operator opens Add Movement Schedule dialog on Movement Management page
    And Operator fill Add Movement Schedule form using data below:
      | originHub      | {KEY_LIST_OF_HUBS_ADMINISTRATION[1].name} |
      | destinationHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[2].name} |
      | applyToAllDays | true                                      |
      | startTime      | 15:15                                     |
      | duration       | 1                                         |
      | endTime        | 18 h 30 m                                 |
    And Operator click "Cancel" button on Add Movement Schedule dialog
    Then Operator verifies Add Movement Schedule dialog is closed on Movement Management page
    And Operator opens Add Movement Schedule dialog on Movement Management page
    Then Operator verify Add Movement Schedule form is empty

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Search Crossdock Movement Schedule - correct crossdock name (uid:)
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
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_HUBS_ADMINISTRATION[1].name} |
      | destinationHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[2].name} |
      | applyToAllDays | true                                      |
      | startTime      | 15:15                                     |
      | duration       | 1                                         |
      | endTime        | 18 h 30 m                                 |
    And Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | originHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[1].name} |
    Then Operator verify schedules list on Movement Management page using data below:
      | originHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[1].name} |
    When Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | destinationHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[2].name} |
    Then Operator verify schedules list on Movement Management page using data below:
      | destinationHub | {KEY_LIST_OF_HUBS_ADMINISTRATION[2].name} |

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Search Crossdock Movement Schedule - wrong crossdock name (uid:)
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | originHub | WRONG_HUB_NAME |
    Then Operator verify schedules list is empty on Movement Management page
    When Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | destinationHub | WRONG_HUB_NAME |
    Then Operator verify schedules list is empty on Movement Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
