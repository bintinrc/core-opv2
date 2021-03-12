@OperatorV2 @Driver @StationManagementTool @DriverPerformance
Feature: Driver Performance

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Load Driver Performance (uid:f8d7669a-dc1a-4edd-8d0d-0d9016d7212c)
    When Operator go to menu Station Management Tool -> Driver Performance
    And Driver Performance page is loaded
    When Operator clicks Show\Hide Filters on Driver Performance page
    Then Operator verifies Filters form is hidden on Driver Performance page
    When Operator clicks Show\Hide Filters on Driver Performance page
    Then Operator verifies Filters form is displayed on Driver Performance page
    And Operator verifies Route Date range is 30 days on Driver Performance page
    And Operator verifies Load Selection button is disabled on Driver Performance page
    When Operator select following filters on Driver Performance page:
      | hubs | JKB |
    Then Operator verifies Load Selection button is enabled on Driver Performance page
    When Operator select following filters on Driver Performance page:
      | driverNames | Andhar Driver |
      | driverTypes | Ops           |
    And Operator clicks Load Selection button on Driver Performance page
    Then Operator verifies Driver Performance record on Driver Performance page:
      | driverName | Andhar Driver |
      | hub        | JKB           |
      | driverType | Ops           |
    And Operator opens individual route date view on Driver Performance page using data below:
      | driverName | Andhar Driver |
      | hub        | JKB           |
    Then Operator verifies Driver Performance records on Driver Performance page:
      | driverName    | hub | routeDate  | driverType |
      | Andhar Driver | JKB | 2021-02-11 | Ops        |
      | Andhar Driver | JKB | 2021-02-12 | Ops        |
    When Operator clicks 'Go back to previous page' button on Driver Performance page
    Then Operator verifies Filters form is displayed on Driver Performance page

  Scenario: Load Driver Performance by Individual Route Date (uid:a1299b53-380f-4f04-9919-c4687f17724c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Station Management Tool -> Driver Performance
    And Driver Performance page is loaded
    When Operator select following filters on Driver Performance page:
      | displayIndividualRows | true          |
      | hubs                  | JKB           |
      | driverNames           | Andhar Driver |
      | driverTypes           | Ops           |
    And Operator clicks Load Selection button on Driver Performance page
    Then Operator verifies Driver Performance records on Driver Performance page:
      | driverName    | hub | routeDate  | driverType |
      | Andhar Driver | JKB | 2021-02-11 | Ops        |
      | Andhar Driver | JKB | 2021-02-12 | Ops        |

  Scenario: Create New Preset (uid:f52c604c-cf95-4c03-a6df-3b92787c194d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Station Management Tool -> Driver Performance
    And Driver Performance page is loaded
    And Operator creates new preset on Driver Performance page:
      | name        | GENERATED     |
      | hubs        | JKB           |
      | driverNames | Andhar Driver |
      | driverTypes | Ops           |
    Then Operator verifies that "New Preset Created" success notification is displayed
    And Operator clicks Clear Selection button on Driver Performance page
    And Operator selects "{KEY_CREATED_DRIVER_PERFORMANCE_PRESET.name}" preset on Driver Performance page
    Then Operator verifies selected filters on Driver Performance page:
      | hubs        | JKB           |
      | driverNames | Andhar Driver |
      | driverTypes | Ops           |

  Scenario: Cannot Create Duplicate Preset (uid:96ac70b4-9393-49f6-896f-2668b3dfd040)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Station Management Tool -> Driver Performance
    And Driver Performance page is loaded
    And Operator creates new preset on Driver Performance page:
      | name        | GENERATED     |
      | hubs        | JKB           |
      | driverNames | Andhar Driver |
      | driverTypes | Ops           |
    Then Operator verifies that "New Preset Created" success notification is displayed
    And Operator clicks Clear Selection button on Driver Performance page
    And Operator select following filters on Driver Performance page:
      | hubs | JKB |
    And Operator opens Save As Preset modal on Driver Performance page
    And Operator enters "{KEY_CREATED_DRIVER_PERFORMANCE_PRESET.name}" name in Save As Preset modal
    Then Operator verifies "Name already exist. Choose another name." error message is displayed in Save As Preset modal
    And Operator verifies Save button is disabled in Save As Preset modal

  Scenario: Update Preset (uid:921dcaa6-2c61-43b9-b14f-e9eb77785499)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Station Management Tool -> Driver Performance
    And Driver Performance page is loaded
    And Operator creates new preset on Driver Performance page:
      | name        | GENERATED     |
      | hubs        | JKB           |
      | driverNames | Andhar Driver |
      | driverTypes | Ops           |
    Then Operator verifies that "New Preset Created" success notification is displayed
    And Operator select following filters on Driver Performance page:
      | hubs        | {hub-name}          |
      | driverNames | {ninja-driver-name} |
      | driverTypes | {driver-type-name}  |
    And Operator updates preset on Driver Performance page
    Then Operator verifies that "Current Preset Updated" success notification is displayed
    When Operator clicks Clear Selection button on Driver Performance page
    And Operator selects "{KEY_CREATED_DRIVER_PERFORMANCE_PRESET.name}" preset on Driver Performance page
    Then Operator verifies selected filters on Driver Performance page:
      | hubs        | {hub-name}          |
      | driverNames | {ninja-driver-name} |
      | driverTypes | {driver-type-name}  |

  Scenario: Delete Preset (uid:5679e590-3596-4fe3-b0bf-e6c1a0ab1785)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Station Management Tool -> Driver Performance
    And Driver Performance page is loaded
    And Operator creates new preset on Driver Performance page:
      | name        | GENERATED     |
      | hubs        | JKB           |
      | driverNames | Andhar Driver |
      | driverTypes | Ops           |
    Then Operator verifies that "New Preset Created" success notification is displayed
    And Operator deletes preset on Driver Performance page
    Then Operator verifies "{KEY_CREATED_DRIVER_PERFORMANCE_PRESET.name}" preset was deleted on Driver Performance page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
