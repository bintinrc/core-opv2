@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroupsV1.5
Feature: Create Route Group V1.5s V1.5 - Shipment Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on Create Route Groups V1.5 Page - Shipment Filters (uid:a1be140c-623f-4d2a-9ec8-2afc56d2ac93)
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator set Shipment Filters on Create Route Group V1.5 page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator selects "Save Current as Preset" shipments preset action on Create Route Group V1.5 page
    Then Operator verifies Save Preset dialog on Create Route Group V1.5 page contains filters:
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name-3}                                                                                    |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | Shipment Status: At Transit Hub                                                                                   |
      | Shipment Type: Air Haul                                                                                           |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00             |
    And Operator verifies Preset Name field in Save Preset dialog on Create Route Group V1.5 page is required
    And Operator verifies Cancel button in Save Preset dialog on Create Route Group V1.5 page is enabled
    And Operator verifies Save button in Save Preset dialog on Create Route Group V1.5 page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Create Route Group V1.5 page
    Then Operator verifies Preset Name field in Save Preset dialog on Create Route Group V1.5 page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on Create Route Group V1.5 page is enabled
    When Operator clicks Save button in Save Preset dialog on Create Route Group V1.5 page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset created                             |
      | bottom             | Name: {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                                |
    And Operator verifies selected shippers Filter Preset name is "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" on Create Route Group V1.5 page
    And DB Operator verifies filter preset record:
      | id        | {KEY_SHIPMENTS_FILTERS_PRESET_ID}             |
      | namespace | shipments                                     |
      | name      | {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group V1.5 page
    And Operator verifies selected Shipment Filters on Create Route Group V1.5 page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on Create Route Groups V1.5 Page - Shipment Filters (uid:76592ef5-4801-49a6-8429-7224a6896a5b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.origHub        | {hub-id}                                     |
      | value.destHub        | {hub-id-2}                                   |
      | value.currHub        | {hub-id-3}                                   |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group V1.5 page
    And Operator verifies selected Shipment Filters on Create Route Group V1.5 page:
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | lastInboundHub | {hub-name-3}   |
      | shipmentStatus | At Transit Hub |
      | shipmentType   | Air Haul       |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Create Route Groups V1.5 Page - Shipment Filters (uid:67fd041a-384e-419e-a965-e95e04da545f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.origHub        | {hub-id}                                     |
      | value.destHub        | {hub-id-2}                                   |
      | value.currHub        | {hub-id-3}                                   |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator selects "Delete Preset" shipments preset action on Create Route Group V1.5 page
    Then Operator verifies Cancel button in Delete Preset dialog on Create Route Group V1.5 page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Create Route Group V1.5 page is disabled
    When Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on Create Route Group V1.5 page
    Then Operator verifies "Preset \"{KEY_SHIPMENTS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Create Route Group V1.5 page
    When Operator clicks Delete button in Delete Preset dialog on Create Route Group V1.5 page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted               |
      | bottom | ID: {KEY_SHIPMENTS_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_SHIPMENTS_FILTERS_PRESET_ID}" filter preset is deleted

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Create Route Groups V1.5 Page - Shipment Filters (uid:12b0df82-823a-4f7d-ad8b-03a397c81394)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group V1.5 page
    And Operator set Shipment Filters on Create Route Group V1.5 page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator selects "Save Current as Preset" shipments preset action on Create Route Group V1.5 page
    Then Operator verifies Save Preset dialog on Create Route Group V1.5 page contains filters:
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name-3}                                                                                    |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | Shipment Status: At Transit Hub                                                                                   |
      | Shipment Type: Air Haul                                                                                           |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00             |
    When Operator enters "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Create Route Group V1.5 page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on Create Route Group V1.5 page
    When Operator clicks Update button in Save Preset dialog on Create Route Group V1.5 page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                   |
      | bottom             | Name: {KEY_SHIPMENTS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                      |
    When Operator refresh page
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group V1.5 page
    And Operator verifies selected Shipment Filters on Create Route Group V1.5 page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Update Preset button on Create Route Groups V1.5 Page - Shipment Filters (uid:8ea83f47-8df7-40af-af0f-1dd27283cd15)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group V1.5 page
    And Operator set Shipment Filters on Create Route Group V1.5 page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator selects "Update Preset" shipments preset action on Create Route Group V1.5 page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                   |
      | bottom             | Name: {KEY_SHIPMENTS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                      |
    When Operator refresh page
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group V1.5 page
    And Operator verifies selected Shipment Filters on Create Route Group V1.5 page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op