@OperatorV2 @Core @Order @AllOrders
Feature: All Orders - Preset Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on All Orders Page (uid:d4c62eac-0614-498b-8d30-9b204a7280f6)
    When Operator go to menu Order -> All Orders
    And Operator selects filters on All Orders page:
      | status            | Transit                            |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipperName       | {filter-shipper-name}              |
      | masterShipperName | {shipper-v4-marketplace-legacy-id} |
    And Operator selects "Save Current as Preset" preset action on All Orders page
    Then Operator verifies Save Preset dialog on All Orders page contains filters:
      | Status: Transit                                                                                   |
      | Creation Time: {gradle-next-0-day-yyyy-MM-dd} 04:00:00 to {gradle-next-1-day-yyyy-MM-dd} 04:00:00 |
      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                                 |
      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name}                  |
    And Operator verifies Preset Name field in Save Preset dialog on All Orders page is required
    And Operator verifies Cancel button in Save Preset dialog on All Orders page is enabled
    And Operator verifies Save button in Save Preset dialog on All Orders page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on All Orders page
    Then Operator verifies Preset Name field in Save Preset dialog on All Orders page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on All Orders page is enabled
    When Operator clicks Save button in Save Preset dialog on All Orders page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset created                    |
      | bottom             | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                       |
    And Operator verifies selected Filter Preset name is "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" on All Orders page
    And DB Operator verifies filter preset record:
      | id        | {KEY_ALL_ORDERS_FILTERS_PRESET_ID}   |
      | namespace | orders                               |
      | name      | {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit                                                          |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on All Orders Page (uid:c75cbb19-213b-4f6c-b7d0-42eec03cd916)
    Given Operator go to menu Utilities -> QRCode Printing
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit                                                          |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on All Orders Page (uid:3dd7afce-4f6a-4620-879e-205a80dd2fff)
    Given Operator go to menu Utilities -> QRCode Printing
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "Delete Preset" preset action on All Orders page
    Then Operator verifies Cancel button in Delete Preset dialog on All Orders page is enabled
    And Operator verifies Delete button in Delete Preset dialog on All Orders page is disabled
    When Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on All Orders page
    Then Operator verifies "Preset \"{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on All Orders page
    When Operator clicks Delete button in Delete Preset dialog on All Orders page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted                |
      | bottom | ID: {KEY_ALL_ORDERS_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_ALL_ORDERS_FILTERS_PRESET_ID}" filter preset is deleted

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on All Orders Page - via Save Current As Preset Button (uid:5f5aa695-09a3-4e14-8271-13bdff312ab1)
    Given Operator go to menu Utilities -> QRCode Printing
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    And Operator updates filters on All Orders page:
      | status         | Transit, Cancelled |
      | granularStatus | Cancelled          |
    And Operator selects "Save Current as Preset" preset action on All Orders page
    Then Operator verifies Save Preset dialog on All Orders page contains filters:
      | Status: Cancelled, Transit                                                       |
      | Granular Status: Cancelled                                                       |
      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                |
      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    When Operator enters "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on All Orders page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on All Orders page
    When Operator clicks Update button in Save Preset dialog on All Orders page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                    |
      | bottom             | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                       |
    When Operator refresh page
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit, Cancelled                                               |
      | granularStatus    | Cancelled                                                        |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset on All Orders Page - via Update Preset Button (uid:4b08b54f-c866-4434-811f-d559d5e0b99e)
    Given Operator go to menu Utilities -> QRCode Printing
    And  API Operator creates new Orders Filter Template using data below:
      | name             | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.statusIds  | 2                                            |
      | value.shipperIds | {shipper-v4-legacy-id}                       |
      | value.undefined  | {shipper-v4-marketplace-legacy-id}           |
    When Operator go to menu Order -> All Orders
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    And Operator updates filters on All Orders page:
      | status         | Transit, Cancelled |
      | granularStatus | Cancelled          |
    And Operator selects "Update Preset" preset action on All Orders page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                    |
      | bottom             | Name: {KEY_ALL_ORDERS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                       |
    When Operator refresh page
    And Operator selects "{KEY_ALL_ORDERS_FILTERS_PRESET_NAME}" Filter Preset on All Orders page
    Then Operator verifies selected filters on All Orders page:
      | status            | Transit, Cancelled                                               |
      | granularStatus    | Cancelled                                                        |
      | shipperName       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | masterShipperName | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op