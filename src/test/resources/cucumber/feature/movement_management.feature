@OperatorV2 @OperatorV2Part2 @MovementManagement
Feature: Movement Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Create New Crossdock Hub (uid:dd1e6f6d-5b0c-4c0c-af60-cb17748a2156)
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
  Scenario: Create New Crossdock Movement Schedule - apply all days - 1 movement scedule/day (uid:abdae2c8-c872-442b-a053-ed71a916c154)
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
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Create New Crossdock Movement Schedule - apply all days - more then 1 movement scedule/day (uid:ddb34cbf-c420-45b6-a581-82dbec11121a)
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
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
      | schedule[1].movement[2].startTime | 17:15                              |
      | schedule[1].movement[2].duration  | 2                                  |
      | schedule[1].movement[2].endTime   | 18 h 30 m                          |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Create New Crossdock Movement Schedule - not all days - 1 movement scedule/day (uid:4405488d-0f69-4f90-adae-2dceb66d2cc4)
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
      | applyToAllDays                    | false                              |
      | schedule[1].day                   | Monday                             |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
      | schedule[2].day                   | Tuesday                            |
      | schedule[2].movement[1].startTime | 17:15                              |
      | schedule[2].movement[1].duration  | 2                                  |
      | schedule[2].movement[1].endTime   | 18 h 30 m                          |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Create New Crossdock Movement Schedule - not all days - more then 1 movement scedule/day (uid:24a32b1e-9791-4e42-9231-b5b6a9302fe9)
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
      | applyToAllDays                    | false                              |
      | schedule[1].day                   | Monday                             |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
      | schedule[1].movement[2].startTime | 17:15                              |
      | schedule[1].movement[2].duration  | 2                                  |
      | schedule[1].movement[2].endTime   | 18 h 30 m                          |
      | schedule[2].day                   | Tuesday                            |
      | schedule[2].movement[1].startTime | 15:15                              |
      | schedule[2].movement[1].duration  | 1                                  |
      | schedule[2].movement[1].endTime   | 16 h 30 m                          |
      | schedule[2].movement[2].startTime | 17:15                              |
      | schedule[2].movement[2].duration  | 2                                  |
      | schedule[2].movement[2].endTime   | 18 h 30 m                          |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Create New Crossdock Movement Schedule - Origin Crossdock Hub same with Destination Crossdock Hub (uid:29f3608a-6d09-4787-87df-4e776f89b608)
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
  Scenario: Cancel Create New Crossdock Movement Schedule (uid:3816b3bb-b453-4d99-94c2-6432b0744e8e)
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
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And Operator click "Cancel" button on Add Movement Schedule dialog
    Then Operator verifies Add Movement Schedule dialog is closed on Movement Management page
    And Operator opens Add Movement Schedule modal on Movement Management page
    Then Operator verify Add Movement Schedule form is empty

  @ArchiveAndDeleteHubViaDb @SwitchToDefaultContent
  Scenario: Search Crossdock Movement Schedule - correct crossdock name (uid:a921ee4c-0bdb-4bc0-94b9-be09a8cfd9be)
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
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
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
  Scenario: Search Crossdock Movement Schedule - wrong crossdock name (uid:f8760200-aebb-4745-a9ba-d87c5c87406f)
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
  Scenario: Delete Crossdock Movement Schedule (uid:537f891d-0131-4a6d-bfb8-dd175a50abb6)
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
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
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
  Scenario: View Crossdock Movement Schedule (uid:00979c7f-39a0-4f12-9c16-2ee31d1341ac)
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
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And Operator load schedules on Movement Management page using data below:
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verifies a new schedule is created on Movement Management page
    When Operator open view modal of a created movement schedule on Movement Management page
    And Operator verifies created movement schedule data on Movement Schedule modal on Movement Management page

  @ArchiveAndDeleteHubViaDb  @DeleteShipment @CloseNewWindows
  Scenario: Crossdock Movement found and there is available schedule (uid:61f65ed7-0b58-4343-b892-92ad0519f203)
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
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And API Operator does the "van-inbound" scan for the shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @ArchiveAndDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Crossdock Movement found and the schedule available on tomorrow (uid:c60cd46c-a341-4d66-b770-599125274204)
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
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | false                              |
      | schedule[1].day                   | {{next-1-day-name}}                |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And API Operator does the "van-inbound" scan for the shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @ArchiveAndDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Crossdock Movement found and available schedule only 1 day in a week (uid:6dc554a3-b602-4181-bfa0-a2a8e6e521ad)
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
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | false                              |
      | schedule[1].day                   | {{next-2-days-name}}               |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And API Operator does the "van-inbound" scan for the shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                             |
      | sla         | {{next-4-days-yyyy-MM-dd}} 07:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @ArchiveAndDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Crossdock Movement found but has no schedule (uid:567c04fb-64fa-4d68-a760-1566bfa6679b)
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
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And API Operator does the "van-inbound" scan for the shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
      | sla         | -                                  |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source   | SLA_CALCULATION                                                                                                          |
      | status   | FAILED                                                                                                                   |
      | comments | found no movement from origin {KEY_LIST_OF_CREATED_HUBS[1].id} (SG) to destination {KEY_LIST_OF_CREATED_HUBS[2].id} (SG) |

  @ArchiveAndDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Crossdock Movement found and do Van Inbound Shipment using MAWB (uid:01813aa8-0f39-4dc9-ad52-a4950bba22cc)
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
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}                                 |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}                                 |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd} |
    When Operator click "Load All Selection" on Shipment Management page
    When Operator edit Shipment on Shipment Management page including MAWB using data below:
      | comments | Modified by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd} |
      | mawb     | AUTO-{gradle-current-date-yyyyMMddHHmmsss}                          |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | false                              |
      | schedule[1].day                   | {{next-2-days-name}}               |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {KEY_LIST_OF_CREATED_HUBS[1].name} on Shipment Inbound Scanning page using MAWB
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                             |
      | sla         | {{next-4-days-yyyy-MM-dd}} 07:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @ArchiveAndDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Facility Type of Origin/Destination Crossdock Hub is changed to 'Station' (uid:c64ee237-d954-4bec-838c-2e224f8b1717)
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
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator adds new Movement Schedule on Movement Management page using data below:
      | originHub                         | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub                    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | applyToAllDays                    | true                               |
      | schedule[1].day                   | Monday-Sunday                      |
      | schedule[1].movement[1].startTime | 15:15                              |
      | schedule[1].movement[1].duration  | 1                                  |
      | schedule[1].movement[1].endTime   | 16 h 30 m                          |
    And Operator go to menu Hubs -> Facilities Management
    When Operator update Hub on page Hubs Administration using data below:
      | searchHubsKeyword | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | facilityType      | Station                            |
    When Operator go to menu Inter-Hub -> Movement Management
    And API Operator does the "van-inbound" scan for the shipment
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
      | sla         | -                                  |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source   | SLA_CALCULATION                                              |
      | status   | FAILED                                                       |
      | comments | relation for {KEY_LIST_OF_CREATED_HUBS[1].id} (SG) not found |

  @ArchiveAndDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Search Station in Pending Relations Tab (uid:3294c0fb-bfe6-4156-bfe7-44e740f2183f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When Operator go to menu Inter-Hub -> Movement Management
    And Movement Management page is loaded
    And Operator search for Pending relation on Movement Management page using data below:
      | station | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify relations table on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | Unfilled                           |
    When Operator search for Pending relation on Movement Management page using data below:
      | station | wrong-station-name |
    Then Operator verify relations table on Movement Management page is empty

  @ArchiveAndDeleteHubViaDb
  Scenario: Update Station Relation (uid:30fd38a6-bd35-48c8-8f83-8e9839798e65)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
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
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Air Haul                           |
      | departureTime  | 15:15                              |
      | duration       | 1                                  |
      | endTime        | 16:30                              |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
