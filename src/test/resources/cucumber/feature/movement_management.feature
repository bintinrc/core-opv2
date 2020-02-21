@OperatorV2 @OperatorV2Part2 @MovementManagement
Feature: Movement Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Operator should be able to create a new Hub on page Hubs Administration (uid:c753d5ed-1026-408e-9c71-0e5b8f4e7aa3)
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    When Movement Management page is loaded
    And Operator opens Add Movement Schedule modal on Movement Management page
    Then Operator can select "{KEY_LIST_OF_CREATED_HUBS[1].name}" crossdock hub when create crossdock movement schedule

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - apply all days - 1 movement scedule/day (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                                |
      | schedule[1].day                   | Monday-Sunday                       |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - apply all days - more then 1 movement scedule/day (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                                |
      | schedule[1].day                   | Monday-Sunday                       |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
      | schedule[1].movement[2].startTime | 17:15                               |
      | schedule[1].movement[2].duration  | 2                                   |
      | schedule[1].movement[2].endTime   | 18 h 30 m                           |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - not all days - 1 movement scedule/day (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | false                               |
      | schedule[1].day                   | Monday                              |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
      | schedule[2].day                   | Tuesday                             |
      | schedule[2].movement[1].startTime | 17:15                               |
      | schedule[2].movement[1].duration  | 2                                   |
      | schedule[2].movement[1].endTime   | 18 h 30 m                           |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - not all days - more then 1 movement scedule/day (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | false                               |
      | schedule[1].day                   | Monday                              |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
      | schedule[1].movement[2].startTime | 17:15                               |
      | schedule[1].movement[2].duration  | 2                                   |
      | schedule[1].movement[2].endTime   | 18 h 30 m                           |
      | schedule[2].day                   | Tuesday                             |
      | schedule[2].movement[1].startTime | 15:15                               |
      | schedule[2].movement[1].duration  | 1                                   |
      | schedule[2].movement[1].endTime   | 16 h 30 m                           |
      | schedule[2].movement[2].startTime | 17:15                               |
      | schedule[2].movement[2].duration  | 2                                   |
      | schedule[2].movement[2].endTime   | 18 h 30 m                           |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Create New Crossdock Movement Schedule - Origin Crossdock Hub same with Destination Crossdock Hub (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator opens Add Movement Schedule modal on Movement Management page
    And Operator fill Add Movement Schedule form using data below:
      | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator can not select "{KEY_LIST_OF_CREATED_HUBS[1].name}" destination crossdock hub on Add Movement Schedule dialog

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Cancel Create New Crossdock Movement Schedule (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator opens Add Movement Schedule modal on Movement Management page
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                                |
      | schedule[1].day                   | Monday-Sunday                       |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
    And Operator click "Cancel" button on Add Movement Schedule dialog
    Then Operator verifies Add Movement Schedule dialog is closed on Movement Management page
    And Operator opens Add Movement Schedule modal on Movement Management page
    Then Operator verify Add Movement Schedule form is empty

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Search Crossdock Movement Schedule - correct crossdock name (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                                |
      | schedule[1].day                   | Monday-Sunday                       |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
    And Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify schedules list on Movement Management page using data below:
      | originHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    When Operator load schedules on Movement Management page
    And Operator filters schedules list on Movement Management page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify schedules list on Movement Management page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Search Crossdock Movement Schedule - wrong crossdock name (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
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

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - Delete Crossdock Movement Schedule (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                                |
      | schedule[1].day                   | Monday-Sunday                       |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page
    When Operator deletes created movement schedule on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify schedules list is empty on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Crossdock Hubs - View Crossdock Movement Schedule (uid:)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                                |
      | schedule[1].day                   | Monday-Sunday                       |
      | schedule[1].movement[1].startTime | 15:15                               |
      | schedule[1].movement[1].duration  | 1                                   |
      | schedule[1].movement[1].endTime   | 16 h 30 m                           |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page
    When Operator open view modal of a created movement schedule on Movement Management page
    And Operator verifies created movement schedule data on Movement Schedule modal on Movement Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
