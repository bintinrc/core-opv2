@OperatorV2 @Core @AllOrders @PresetFilters
Feature: All Orders - Preset Filters

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on All Orders Page
    When Operator go to menu Order -> All Orders
    And Operator selects filters on All Orders page:
      | status            | Transit                            |
      | creationTimeFrom  | {date: 1 days ago, yyyy-MM-dd}     |
      | creationTimeTo    | {date: 1 days next, yyyy-MM-dd}    |
      | shipperName       | {filter-shipper-name}              |
      | masterShipperName | {shipper-v4-marketplace-legacy-id} |
    And Operator selects "Save Current as Preset" preset action on All Orders page
    Then Operator verifies Save Preset dialog on All Orders page contains filters:
      | commons.status: Transit                                                                                    |
      | commons.creation-time: {date: 1 days ago, yyyy-MM-dd} 12:00:00 to {date: 1 days next, yyyy-MM-dd} 12:00:00 |
      | commons.shipper: {shipper-v4-name}                                                                         |
      | commons.master-shipper: {shipper-v4-marketplace-name}                                                      |
    And Operator verifies Preset Name field in Save Preset dialog on All Orders page is required
    And Operator verifies Cancel button in Save Preset dialog on All Orders page is enabled
    And Operator verifies Save button in Save Preset dialog on All Orders page is disabled
    When Operator enters "PRESET {date: 0 days next, yyyyMMddHHmmss}" Preset Name in Save Preset dialog on All Orders page
    Then Operator verifies Preset Name field in Save Preset dialog on All Orders page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on All Orders page is enabled
    When Operator clicks Save button in Save Preset dialog on All Orders page
    Then Operator verifies that success toast displayed:
      | top    | 1 filter preset created                    |
      | bottom | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
    And Operator verifies selected Filter Preset name is "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" on All Orders page
    And DB Operator verifies filter preset record:
      | id        | {KEY_ALL_ORDERS_FILTERS_PRESET_ID}   |
      | namespace | orders                               |
      | name      | {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit                         |
      | creationTimeFrom  | {date: 1 days ago, yyyy-MM-dd}  |
      | creationTimeTo    | {date: 1 days next, yyyy-MM-dd} |
      | shipperName       | {shipper-v4-name}               |
      | masterShipperName | {shipper-v4-marketplace-name}   |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Lighthouse - creates new Orders Filter Template using data below:
      | name             | PRESET {date: 0 days next, yyyyMMddHHmmss} |
      | value.statusIds  | 2                                          |
      | value.shipperIds | {shipper-v4-legacy-id}                     |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}         |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit                       |
      | shipperName       | {shipper-v4-name}             |
      | masterShipperName | {shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Lighthouse - creates new Orders Filter Template using data below:
      | name             | PRESET {date: 0 days next, yyyyMMddHHmmss} |
      | value.statusIds  | 2                                          |
      | value.shipperIds | {shipper-v4-legacy-id}                     |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}         |
    When Operator go to menu Order -> All Orders
    And Operator selects "Delete Preset" preset action on All Orders page
    Then Operator verifies Cancel button in Delete Preset dialog on All Orders page is enabled
    And Operator verifies Delete button in Delete Preset dialog on All Orders page is disabled
    When Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" preset in Delete Preset dialog on All Orders page
    Then Operator verifies "Preset \"{KEY_ALL_ORDERS_FILTERS_PRESET.name}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on All Orders page
    When Operator clicks Delete button in Delete Preset dialog on All Orders page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted                |
      | bottom | ID: {KEY_ALL_ORDERS_FILTERS_PRESET.id} |
    And DB Lighthouse - verify preset_filters id "{KEY_ALL_ORDERS_FILTERS_PRESET.id}" record is deleted:

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on All Orders Page - via Save Current As Preset Button
    Given Operator go to menu Utilities -> QRCode Printing
    And API Lighthouse - creates new Orders Filter Template using data below:
      | name             | PRESET {date: 0 days next, yyyyMMddHHmmss} |
      | value.statusIds  | 2                                          |
      | value.shipperIds | {shipper-v4-legacy-id}                     |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}         |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" Filter Preset on All Orders page
    And Operator updates filters on All Orders page:
      | status         | Transit, Cancelled |
      | granularStatus | Cancelled          |
    And Operator selects "Save Current as Preset" preset action on All Orders page
    Then Operator verifies Save Preset dialog on All Orders page contains filters:
      | Status: Cancelled, Transit                    |
      | Granular Status: Cancelled                    |
      | Shipper: {shipper-v4-name}                    |
      | Master Shipper: {shipper-v4-marketplace-name} |
    When Operator enters "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" Preset Name in Save Preset dialog on All Orders page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on All Orders page
    When Operator clicks Update button in Save Preset dialog on All Orders page
    Then Operator verifies that success toast displayed:
      | top    | 1 filter preset updated                    |
      | bottom | Name: {KEY_ALL_ORDERS_FILTERS_PRESET.name} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit, Cancelled            |
      | granularStatus    | Cancelled                     |
      | shipperName       | {shipper-v4-name}             |
      | masterShipperName | {shipper-v4-marketplace-name} |


  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on All Orders Page - via Update Preset Button
    Given Operator go to menu Utilities -> QRCode Printing
    And API Lighthouse - creates new Orders Filter Template using data below:
      | name             | PRESET {date: 0 days next, yyyyMMddHHmmss} |
      | value.statusIds  | 2                                          |
      | value.shipperIds | {shipper-v4-legacy-id}                     |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}         |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" Filter Preset on All Orders page
    And Operator updates filters on All Orders page:
      | status         | Transit, Cancelled |
      | granularStatus | Cancelled          |
    And Operator selects "Update Preset" preset action on All Orders page
    Then Operator verifies that success toast displayed:
      | top    | 1 filter preset updated                    |
      | bottom | Name: {KEY_ALL_ORDERS_FILTERS_PRESET.name} |
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET.name}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit, Cancelled            |
      | granularStatus    | Cancelled                     |
      | shipperName       | {shipper-v4-name}             |
      | masterShipperName | {shipper-v4-marketplace-name} |

