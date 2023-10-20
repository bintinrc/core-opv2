@OperatorV2 @Core @Routing @RouteLogs @PresetFiltersRouteLogs
Feature: Route Logs - Preset Filters

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on Route Logs Page
    Given Operator go to menu Routing -> Route Logs
    And Operator set filters on Route Logs page:
      | routeDateFrom  | {date: 1 days ago, dd/MM/yyyy}  |
      | routeDateTo    | {date: 0 days next, dd/MM/yyyy} |
      | hub            | {hub-name}                      |
      | driver         | {ninja-driver-name}             |
      | archivedRoutes | true                            |
    And Operator selects "Save Current As Preset" preset action on Route Logs page
    Then Operator verifies Save Preset dialog on Route Logs page contains filters:
      | Route date: {date: 1 days ago, YYYY-MM-dd} to {date: 0 days next, YYYY-MM-dd} |
      | Hub: (1) {hub-name}                                                           |
      | Driver: (1) {ninja-driver-name}                                               |
      | Archived routes: Show archived routes                                         |
    And Operator verifies Preset Name field in Save Preset dialog on Route Logs page is required
    And Operator verifies Cancel button in Save Preset dialog on Route Logs page is enabled
    And Operator verifies Save button in Save Preset dialog on Route Logs page is disabled
    When Operator enters "PRESET {date: 0 days next, yyyyMMddHHmmssSSSS}" Preset Name in Save Preset dialog on Route Logs page
    And Operator verifies Save button in Save Preset dialog on Route Logs page is enabled
    When Operator clicks Save button in Save Preset dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset created              |
      | bottom             | Name: {KEY_CORE_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                 |
    And Operator verifies selected Filter Preset name is "{KEY_CORE_FILTERS_PRESET_NAME}" on Route Logs page
    And DB Lighthouse - verify preset_filters record:
      | id        | {KEY_CORE_FILTERS_PRESET_ID}   |
      | namespace | routes                         |
      | name      | {KEY_CORE_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {date: 1 days ago, dd/MM/yyyy}  |
      | routeDateTo    | {date: 0 days next, dd/MM/yyyy} |
      | hub            | {hub-name}                      |
      | driver         | {ninja-driver-name}             |
      | archivedRoutes | true                            |

  @DeleteFilterTemplate @wip
  Scenario: Operator Apply Filter Preset on Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-yyyy-MM-dd}           |
      | value.endDate   | {gradle-current-date-yyyy-MM-dd}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | true                                         |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-1-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-current-date-dd/MM/yyyy}   |
      | hub            | {hub-name}                         |
      | driver         | {ninja-driver-name}                |
      | archivedRoutes | true                               |
      | zone           | {zone-name}                        |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Route Logs Page
    Given API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-yyyy-MM-dd}           |
      | value.endDate   | {gradle-current-date-yyyy-MM-dd}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | false                                        |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    And Operator set filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-2-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-previous-1-day-dd/MM/yyyy} |
      | hub            | {hub-name-2}                       |
      | driver         | {ninja-driver-2-name}              |
      | archivedRoutes | true                               |
    And Operator selects "Save Current As Preset" preset action on Route Logs page
    Then Operator verifies Save Preset dialog on Route Logs page contains filters:
      | Route date: {gradle-previous-2-day-yyyy-MM-dd} to {gradle-previous-1-day-yyyy-MM-dd} |
      | Hub: (1) {hub-name-2}                                                                |
      | Driver: (1) {ninja-driver-2-name}                                                    |
      | Archived routes: Show archived routes                                                |
    When Operator enters "{KEY_CORE_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Route Logs page
    Then Operator verifies help text "This name is already taken. Click update to overwrite the preset?" is displayed in Save Preset dialog on Route Logs page
    When Operator clicks Update button in Save Preset dialog on Rout Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset updated              |
      | bottom             | Name: {KEY_CORE_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                 |
    When Operator refresh page
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-2-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-previous-1-day-dd/MM/yyyy} |
      | hub            | {hub-name-2}                       |
      | driver         | {ninja-driver-2-name}              |
      | archivedRoutes | true                               |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Update Preset button on Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-yyyy-MM-dd}           |
      | value.endDate   | {gradle-current-date-yyyy-MM-dd}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | false                                        |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    And Operator set filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-2-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-previous-1-day-dd/MM/yyyy} |
      | hub            | {hub-name-2}                       |
      | driver         | {ninja-driver-2-name}              |
      | archivedRoutes | true                               |
    And Operator selects "Update Preset" preset action on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset updated              |
      | bottom             | Name: {KEY_CORE_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                 |
    When Operator refresh page
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    Then Operator verifies selected filters on Route Logs page:
      | routeDateFrom  | {gradle-previous-2-day-dd/MM/yyyy} |
      | routeDateTo    | {gradle-previous-1-day-dd/MM/yyyy} |
      | hub            | {hub-name-2}                       |
      | driver         | {ninja-driver-2-name}              |
      | archivedRoutes | true                               |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Route Logs Page
    Given API Operator creates new Routes Filter Template using data below:
      | name            | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.startDate | {gradle-previous-1-day-dd/MM/yyyy}           |
      | value.endDate   | {gradle-current-date-dd/MM/yyyy}             |
      | value.hubIds    | {hub-id}                                     |
      | value.driverIds | {ninja-driver-id}                            |
      | value.zoneIds   | {zone-id}                                    |
      | value.archived  | false                                        |
    When Operator go to menu Routing -> Route Logs
    And Operator selects "{KEY_CORE_FILTERS_PRESET_NAME}" Filter Preset on Route Logs page
    And Operator selects "Delete Preset" preset action on Route Logs page
    Then Operator verifies Cancel button in Delete Preset dialog on Route Logs page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Route Logs page is enabled
    When Operator verifies "{KEY_CORE_FILTERS_PRESET_NAME}" preset is selected in Delete Preset dialog on Route Logs page
    Then Operator verifies "Preset {KEY_CORE_FILTERS_PRESET_ID} will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Route Logs page
    When Operator clicks Delete button in Delete Preset dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 filter preset deleted          |
      | bottom | ID: {KEY_CORE_FILTERS_PRESET_ID} |
    And DB Lighthouse - verify preset_filters id "{KEY_CORE_FILTERS_PRESET_ID}" record is deleted:
