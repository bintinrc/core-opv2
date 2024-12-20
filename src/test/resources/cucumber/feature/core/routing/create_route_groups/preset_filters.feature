@OperatorV2 @Core @Routing  @CreateRouteGroups @PresetFiltersCRG
Feature: Create Route Groups - Preset Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6247900

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Save A New Preset on Create Route Groups Page
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6091632
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}     |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}     |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}     |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}     |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipper           | {filter-shipper-name}              |
      | routed            | Show                               |
      | masterShipper     | {shipper-v4-marketplace-legacy-id} |
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-1-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-1-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | AIR_HAUL                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator selects "Save Current As Preset" preset action on Create Route Groups page
    Then Operator verifies Save Preset dialog on Create Route Groups page contains filters:
      | Creation Time: {gradle-next-0-day-yyyy-MM-dd} 00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00     |
      | Delivery Type: (1) (13) C2C 1 Day - Anytime                                                     |
      | DNR Group: (1) SAME_DAY                                                                         |
      | End Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                  |
      | End Hub: (1) CORE-OPV2-HUB-2                                                                    |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}               |
      | Granular Order Status: (1) Arrived at Sorting Hub                                               |
      | Last Inbound Hub: (1) JKB                                                                       |
      | Master Shipper: (1) {shipper-v4-marketplace-legacy-id} - OPV2-Core-Marketplace-Shipper          |
      | Order Service Type: (1) Corporate Document                                                      |
      | Order Type: (1) Normal                                                                          |
      | Parcel Size: (1) Extra Large                                                                    |
      | Pick Up Size: (1) Less than 10 parcels                                                          |
      | PP/DD Leg: (1) DD                                                                               |
      | Reservation Status: (1) SUCCESS                                                                 |
      | Reservation Type: (1) Hyperlocal                                                                |
      | Routed: Show                                                                                    |
      | RTS: Show                                                                                       |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd} |
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00     |
      | Shipment Status: (1) At Transit Hub                                                             |
      | Shipment Type: (1) AIR_HAUL                                                                     |
      | Shipper: (1) {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id})                         |
      | Show Reservation: Show                                                                          |
      | Show Shipment: Show                                                                             |
      | Show Transaction: Show                                                                          |
      | Start Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                |
      | Start Hub: (1) OPV2-CORE-HUB                                                                    |
      | Timeslots: (1) Day                                                                              |
      | Transaction Status: (1) Success                                                                 |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00 |
      | Zone: (1) OPV2-CORE-ZONE                                                                        |
    And Operator verifies Cancel button in Save Preset dialog on Create Route Groups page is enabled
    And Operator verifies Save button in Save Preset dialog on Create Route Groups page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Create Route Groups page
    And Operator verifies Save button in Save Preset dialog on Create Route Groups page is enabled
    When Operator clicks Save button in Save Preset dialog on Create Route Groups page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset created                                            |
      | bottom             | Name: {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name} |
      | waitUntilInvisible | true                                                               |
    And Operator verifies selected Filter Preset name is "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" on Create Route Groups page
    And DB Lighthouse - verify preset_filters record:
      | id        | {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].id}   |
      | namespace | route-groups                                                 |
      | name      | {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name} |
    When Operator refresh page
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    Then Operator verifies selected General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id})         |
      | routed            | Show                                                               |
      | masterShipper     | {shipper-v4-marketplace-legacy-id} - {shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator verifies selected Reservation Filters on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator verifies selected Shipment Filters on Create Route Groups page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-1-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-1-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | AIR_HAUL                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-1-day-yyyy-MM-dd} |

  @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Apply Existing Filter Preset on Create Route Groups Page
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6091631
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderGranularStatusIds  | 6                                            |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.orderTypeIds            | 0                                            |
      | value.typeIds                 | 1                                            |
      | value.statusIds               | 2                                            |
      | value.isRts                   | true                                         |
      | value.orderSizeIds            | 3                                            |
      | value.timeslotIds             | -2                                           |
      | value.deliveryTypeIds         | 13                                           |
      | value.dnrIds                  | 9                                            |
      | value.approxVolumeValues      | Less than 10 Parcels                         |
      | value.reservationTypeIds      | 2                                            |
      | value.reservationStatusIds    | 1                                            |
      | value.origHub                 | {hub-id}                                     |
      | value.destHub                 | {hub-id-2}                                   |
      | value.currHub                 | {hub-id}                                     |
      | value.shipmentStatus          | AT_TRANSIT_HUB                               |
      | value.shipmentType            | AIR_HAUL                                     |
      | value.showTransaction         | true                                         |
      | value.showReservation         | true                                         |
      | value.showShipment            | true                                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    Then Operator verifies selected General Filters on Create Route Groups page:
      | shipper       | {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id})         |
      | routed        | Show                                                               |
      | masterShipper | {shipper-v4-marketplace-legacy-id} - {shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator verifies selected Reservation Filters on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator verifies selected Shipment Filters on Create Route Groups page:
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | lastInboundHub | {hub-name}     |
      | shipmentStatus | At Transit Hub |
      | shipmentType   | AIR_HAUL       |

  @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Delete Preset on Create Route Groups Page
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6091645
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderGranularStatusIds  | 6                                            |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.isRts                   | true                                         |
      | value.orderSizeIds            | 3                                            |
      | value.timeslotIds             | -2                                           |
      | value.deliveryTypeIds         | 13                                           |
      | value.dnrIds                  | 9                                            |
      | value.approxVolumeValues      | Less than 10 Parcels                         |
      | value.reservationTypeIds      | 2                                            |
      | value.reservationStatusIds    | 1                                            |
      | value.origHub                 | {hub-id}                                     |
      | value.destHub                 | {hub-id-2}                                   |
      | value.currHub                 | {hub-id}                                     |
      | value.showTransaction         | true                                         |
      | value.showReservation         | true                                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    And Operator selects "Delete Preset" preset action on Create Route Groups page
    Then Operator verifies "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" preset is selected in Delete Preset dialog on Create Route Groups page
    Then Operator verifies "Preset {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].id} will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Create Route Groups page
    Then Operator verifies Cancel button in Delete Preset dialog on Create Route Groups page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Create Route Groups page is enabled
    When Operator clicks Delete button in Delete Preset dialog on Create Route Groups page
    Then Operator verifies that success react notification displayed:
      | top    | 1 filter preset deleted                                        |
      | bottom | ID: {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].id} |
    And DB Lighthouse - verify preset_filters id "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].id}" record is deleted:

  @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Create Route Groups Page
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6091635
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.isRts                   | true                                         |
      | value.approxVolumeValues      | Less than 10 Parcels                         |
      | value.origHub                 | {hub-id}                                     |
      | value.destHub                 | {hub-id-2}                                   |
      | value.currHub                 | {hub-id-3}                                   |
      | value.showTransaction         | true                                         |
      | value.showReservation         | true                                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    And Operator set General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}     |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}     |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}     |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}     |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipper           | {filter-shipper-name}              |
      | routed            | Show                               |
      | masterShipper     | {shipper-v4-marketplace-legacy-id} |
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-1-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-1-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | AIR_HAUL                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator selects "Save Current As Preset" preset action on Create Route Groups page
    Then Operator verifies Save Preset dialog on Create Route Groups page contains filters:
      | Start Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                |
      | End Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                  |
      | Creation Time: {gradle-next-0-day-yyyy-MM-dd} 00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00     |
      | Shipper: (1) {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id})                         |
      | Routed: Show                                                                                    |
      | Master Shipper: (1) {shipper-v4-marketplace-legacy-id} - {shipper-v4-marketplace-name}          |
      | Granular Order Status: (1) Arrived at Sorting Hub                                               |
      | Order Service Type: (1) Corporate Document                                                      |
      | Zone: (1) {zone-name}                                                                           |
      | Order Type: (1) Normal                                                                          |
      | RTS: Show                                                                                       |
      | Transaction Status: (1) Success                                                                 |
      | Parcel Size: (1) Extra Large                                                                    |
      | Timeslots: (1) Day                                                                              |
      | Delivery Type: (1) (13) C2C 1 Day - Anytime                                                     |
      | DNR Group: (1) SAME_DAY                                                                         |
      | PP/DD Leg: (1) DD                                                                               |
      | Pick Up Size: (1) Less than 10 parcels                                                          |
      | Reservation Type: (1) Hyperlocal                                                                |
      | Reservation Status: (1) SUCCESS                                                                 |
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00     |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}               |
      | Start Hub: (1) {hub-name}                                                                       |
      | Last Inbound Hub: (1) {hub-name-3}                                                              |
      | End Hub: (1) {hub-name-2}                                                                       |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd} |
      | Shipment Status: (1) At Transit Hub                                                             |
      | Shipment Type: (1) AIR_HAUL                                                                     |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00 |
      | Show Transaction: Show                                                                          |
      | Show Reservation: Show                                                                          |
      | Show Shipment: Show                                                                             |
    When Operator enters "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Preset Name in Save Preset dialog on Create Route Groups page
    Then Operator verifies help text "This name is already taken. Click update to overwrite the preset?" is displayed in Save Preset dialog on Create Route Groups page
    When Operator clicks Update button in Save Preset dialog on Create Route Groups page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset updated                                            |
      | bottom             | Name: {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name} |
      | waitUntilInvisible | true                                                               |
    When Operator refresh page
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    Then Operator verifies selected General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id})         |
      | routed            | Show                                                               |
      | masterShipper     | {shipper-v4-marketplace-legacy-id} - {shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator verifies selected Reservation Filters on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator verifies selected Shipment Filters on Create Route Groups page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-1-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-1-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name-3}                   |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | AIR_HAUL                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-1-day-yyyy-MM-dd} |

  @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Update Existing Preset via Update Preset button on Create Route Groups Page
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6091636
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.isRts                   | true                                         |
      | value.approxVolumeValues      | Less than 10 Parcels                         |
      | value.origHub                 | {hub-id}                                     |
      | value.destHub                 | {hub-id-2}                                   |
      | value.currHub                 | {hub-id-3}                                   |
      | value.showTransaction         | true                                         |
      | value.showReservation         | true                                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    And Operator set General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}     |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}     |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}     |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}     |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipper           | {filter-shipper-name}              |
      | routed            | Show                               |
      | masterShipper     | {shipper-v4-marketplace-legacy-id} |
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator set Shipment Filters on Create Route Groups page:
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
      | shipmentType                   | AIR_HAUL                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator selects "Update Preset" preset action on Create Route Groups page
    Then Operator verifies that success react notification displayed:
      | top                | 1 filter preset updated                                            |
      | bottom             | Name: {KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name} |
      | waitUntilInvisible | true                                                               |
    When Operator refresh page
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    Then Operator verifies selected General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                     |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                     |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id})         |
      | routed            | Show                                                               |
      | masterShipper     | {shipper-v4-marketplace-legacy-id} - {shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Corporate Document     |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME_DAY               |
    And Operator verifies selected Reservation Filters on Create Route Groups page:
      | pickUpSize        | Less than 10 parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | SUCCESS              |
    And Operator verifies selected Shipment Filters on Create Route Groups page:
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
      | shipmentType                   | AIR_HAUL                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteRouteGroupsV2 @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Add Waypoint To Existing Route Group By Selected Filter Preset
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6247899
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Route - create route group:
      | name        | FCRG-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss}  |
      | value.orderCreateTimeFrom     | {gradle-next-0-day-yyyy-MM-dd}T00:00:00+08:00 |
      | value.orderCreateTimeTo       | {gradle-next-1-day-yyyy-MM-dd}T00:00:00+08:00 |
      | value.shipperIds              | {shipper-v4-legacy-id}                        |
      | value.orderDetailServiceTypes | PARCEL                                        |
      | value.deliveryTypeIds         | 2                                             |
      | value.showTransaction         | true                                          |
      | value.showReservations        | false                                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    And Operator adds following transactions to Route Group "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" on Create Route Groups:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies that success react notification displayed:
      | top | Added successfully |
    Then Operator verifies selected General Filters on Create Route Groups page:
      | shipper | {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id}) |
    And Operator verifies selected Transactions Filters on Create Route Groups page:
      | orderServiceType | Parcel Delivery  |
      | deliveryType     | 3 Days - Anytime |

  @DeleteRouteGroupsV2 @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Add Waypoint To New Route Group By Selected Filter Preset
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142862/scenarios/6247900
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss}  |
      | value.orderCreateTimeFrom     | {gradle-next-0-day-yyyy-MM-dd}T00:00:00+08:00 |
      | value.orderCreateTimeTo       | {gradle-next-1-day-yyyy-MM-dd}T00:00:00+08:00 |
      | value.shipperIds              | {shipper-v4-legacy-id}                        |
      | value.orderDetailServiceTypes | PARCEL                                        |
      | value.deliveryTypeIds         | 2                                             |
      | value.showTransaction         | true                                          |
      | value.showReservations        | false                                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    When Operator adds following transactions to new Route Group "FCRG4-{gradle-current-date-yyyyMMddHHmmsss}" on Create Route Groups page:
      | trackingId                            | type     |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | PICKUP   |
    Then Operator verifies that success react notification displayed:
      | top | Added successfully |
    And Operator verifies selected General Filters on Create Route Groups page:
      | shipper | {shipper-v4-legacy-id}-{shipper-v4-name} ({shipper-v4-id}) |
    And Operator verifies selected Transactions Filters on Create Route Groups page:
      | orderServiceType | Parcel Delivery  |
      | deliveryType     | 3 Days - Anytime |