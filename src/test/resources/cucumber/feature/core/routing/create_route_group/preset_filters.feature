@OperatorV2 @Core @Routing @RoutingJob2 @CreateRouteGroups
Feature: Create Route Groups - Preset Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on Create Route Groups Page - All Search Filters (uid:3da5f28e-4c54-4988-9848-f8955fe15ed3)
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}                                           |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator add following filters on Transactions Filters section on Create Route Group page:
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
      | dnrGroup            | SAME DAY               |
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Save Current as Preset" preset action on Create Route Group page
    Then Operator verifies Save Preset dialog on Create Route Group page contains filters:
      | Start Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                                  |
      | End Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                                    |
      | Creation Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00:00                 |
      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                                                 |
      | Routed: Show                                                                                                      |
      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name}                                  |
      | Granular Order Status: Arrived at Sorting Hub                                                                     |
      | Order Service Type: Corporate Document                                                                            |
      | Zone: {zone-name}                                                                                                 |
      | Order Type: Normal                                                                                                |
      | PP/DD Leg: DD                                                                                                     |
      | Transaction Status: Success                                                                                       |
      | RTS: Show                                                                                                         |
      | Parcel Size: Extra Large                                                                                          |
      | Timeslots: Day                                                                                                    |
      | Delivery Type: (13) C2C 1 Day - Anytime                                                                           |
      | DNR Group: 9 - SAME DAY                                                                                           |
      | Pick Up Size: Less than 10 Parcels                                                                                |
      | Reservation Type: Hyperlocal                                                                                      |
      | Reservation Status: Success                                                                                       |
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name-3}                                                                                    |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | Shipment Status: At Transit Hub                                                                                   |
      | Shipment Type: Air Haul                                                                                           |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00             |
      | Show Transaction: Show                                                                                            |
      | Show Reservation: Show                                                                                            |
    And Operator verifies Preset Name field in Save Preset dialog on Create Route Group page is required
    And Operator verifies Cancel button in Save Preset dialog on Create Route Group page is enabled
    And Operator verifies Save button in Save Preset dialog on Create Route Group page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Create Route Group page
    Then Operator verifies Preset Name field in Save Preset dialog on Create Route Group page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on Create Route Group page is enabled
    When Operator clicks Save button in Save Preset dialog on Create Route Group page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset created                             |
      | bottom             | Name: {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                                |
    And Operator verifies selected Filter Preset name is "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" on Create Route Group page
    And DB Operator verifies filter preset record:
      | id        | {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID}   |
      | namespace | route-groups                                  |
      | name      | {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    Then Operator verifies selected General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Document               |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
    And Operator verifies selected Reservation Filters on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator verifies selected Shipment Filters on Create Route Group page:
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
  Scenario: Operator Apply Filter Preset on Create Route Groups Page - All Search Filters (uid:42c4c74c-291e-4bcf-9c8e-c9348d86ff89)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Route Groups Filter Template using data below:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderGranularStatusIds  | 6                                            |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.orderTypeIds            | 0                                            |
      | value.typeIds                 | 1                                            |
      | value.statusIds               | 6                                            |
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
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    Then Operator verifies selected General Filters on Create Route Group page:
      | shipper       | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed        | Show                                                             |
      | masterShipper | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Document               |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Forced Success         |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
    And Operator verifies selected Reservation Filters on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator verifies selected Shipment Filters on Create Route Group page:
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | lastInboundHub | {hub-name}     |
      | shipmentStatus | At Transit Hub |
      | shipmentType   | Air Haul       |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Create Route Groups Page - All Search Filters (uid:411451e2-5825-4678-a1b2-c56ad91d65b7)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Route Groups Filter Template using data below:
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
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    And Operator selects "Delete Preset" preset action on Create Route Group page
    Then Operator verifies Cancel button in Delete Preset dialog on Create Route Group page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Create Route Group page is disabled
    When Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on Create Route Group page
    Then Operator verifies "Preset \"{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Create Route Group page
    When Operator clicks Delete button in Delete Preset dialog on Create Route Group page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted                         |
      | bottom | ID: {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID}" filter preset is deleted

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Create Route Groups Page - All Search Filters (uid:349131bc-d3e5-48b4-b0fa-249323f70073)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Route Groups Filter Template using data below:
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
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    And Operator set General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}                                           |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator add following filters on Transactions Filters section on Create Route Group page:
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
      | dnrGroup            | SAME DAY               |
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Save Current as Preset" preset action on Create Route Group page
    Then Operator verifies Save Preset dialog on Create Route Group page contains filters:
      | Start Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                                  |
      | End Datetime: {gradle-next-0-day-yyyy-MM-dd} to {gradle-next-1-day-yyyy-MM-dd}                                    |
      | Creation Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-1-day-yyyy-MM-dd} 00:00:00                 |
      | Shipper: {shipper-v4-legacy-id}-{shipper-v4-name}                                                                 |
      | Routed: Show                                                                                                      |
      | Master Shipper: {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name}                                  |
      | Granular Order Status: Arrived at Sorting Hub                                                                     |
      | Order Service Type: Corporate Document                                                                            |
      | Zone: {zone-name}                                                                                                 |
      | Order Type: Normal                                                                                                |
      | PP/DD Leg: DD                                                                                                     |
      | Transaction Status: Success                                                                                       |
      | RTS: Show                                                                                                         |
      | Parcel Size: Extra Large                                                                                          |
      | Timeslots: Day                                                                                                    |
      | Delivery Type: (13) C2C 1 Day - Anytime                                                                           |
      | DNR Group: 9 - SAME DAY                                                                                           |
      | Pick Up Size: Less than 10 Parcels                                                                                |
      | Reservation Type: Hyperlocal                                                                                      |
      | Reservation Status: Success                                                                                       |
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name-3}                                                                                    |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | Shipment Status: At Transit Hub                                                                                   |
      | Shipment Type: Air Haul                                                                                           |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00             |
      | Show Transaction: Show                                                                                            |
      | Show Reservation: Show                                                                                            |
    When Operator enters "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Create Route Group page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on Create Route Group page
    When Operator clicks Update button in Save Preset dialog on Create Route Group page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                             |
      | bottom             | Name: {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                                |
    When Operator refresh page
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    Then Operator verifies selected General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Document               |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Forced Success         |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
    And Operator verifies selected Reservation Filters on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator verifies selected Shipment Filters on Create Route Group page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeFrom                | {gradle-next-0-day-yyyy-MM-dd} |
      | etaDateTimeTo                  | {gradle-next-0-day-yyyy-MM-dd} |
      | startHub                       | {hub-name}                     |
      | endHub                         | {hub-name-2}                   |
      | lastInboundHub                 | {hub-name}                     |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Update Preset button on Create Route Groups Page - All Search Filters (uid:58afae4b-3775-4daa-bfe9-5aceb1543986)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Route Groups Filter Template using data below:
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
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    And Operator set General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}                                           |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Document               |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Update Preset" preset action on Create Route Group page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                             |
      | bottom             | Name: {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                                |
    When Operator refresh page
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    Then Operator verifies selected General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | granularOrderStatus | Arrived at Sorting Hub |
      | orderServiceType    | Document               |
      | zone                | {zone-name}            |
      | orderType           | Normal                 |
      | ppDdLeg             | DD                     |
      | transactionStatus   | Success                |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
    And Operator verifies selected Reservation Filters on Create Route Group page:
      | pickUpSize        | Less than 10 Parcels |
      | reservationType   | Hyperlocal           |
      | reservationStatus | Success              |
    And Operator verifies selected Shipment Filters on Create Route Group page:
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
  Scenario: Operator Save A New Preset on Create Route Groups Page - Shipment Filters (uid:a1be140c-623f-4d2a-9ec8-2afc56d2ac93)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Save Current as Preset" shipments preset action on Create Route Group page
    Then Operator verifies Save Preset dialog on Create Route Group page contains filters:
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name-3}                                                                                    |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | Shipment Status: At Transit Hub                                                                                   |
      | Shipment Type: Air Haul                                                                                           |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00             |
    And Operator verifies Preset Name field in Save Preset dialog on Create Route Group page is required
    And Operator verifies Cancel button in Save Preset dialog on Create Route Group page is enabled
    And Operator verifies Save button in Save Preset dialog on Create Route Group page is disabled
    When Operator enters "PRESET {gradle-current-date-yyyyMMddHHmmsss}" Preset Name in Save Preset dialog on Create Route Group page
    Then Operator verifies Preset Name field in Save Preset dialog on Create Route Group page has green checkmark on it
    And Operator verifies Save button in Save Preset dialog on Create Route Group page is enabled
    When Operator clicks Save button in Save Preset dialog on Create Route Group page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset created                             |
      | bottom             | Name: {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                                |
    And Operator verifies selected shippers Filter Preset name is "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" on Create Route Group page
    And DB Operator verifies filter preset record:
      | id        | {KEY_SHIPMENTS_FILTERS_PRESET_ID}             |
      | namespace | shipments                                     |
      | name      | {KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME} |
    When Operator refresh page
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator verifies selected Shipment Filters on Create Route Group page:
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
  Scenario: Operator Apply Filter Preset on Create Route Groups Page - Shipment Filters (uid:76592ef5-4801-49a6-8429-7224a6896a5b)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.origHub        | {hub-id}                                     |
      | value.destHub        | {hub-id-2}                                   |
      | value.currHub        | {hub-id-3}                                   |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator verifies selected Shipment Filters on Create Route Group page:
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | lastInboundHub | {hub-name-3}   |
      | shipmentStatus | At Transit Hub |
      | shipmentType   | Air Haul       |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Create Route Groups Page - Shipment Filters (uid:67fd041a-384e-419e-a965-e95e04da545f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.origHub        | {hub-id}                                     |
      | value.destHub        | {hub-id-2}                                   |
      | value.currHub        | {hub-id-3}                                   |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator selects "Delete Preset" shipments preset action on Create Route Group page
    Then Operator verifies Cancel button in Delete Preset dialog on Create Route Group page is enabled
    And Operator verifies Delete button in Delete Preset dialog on Create Route Group page is disabled
    When Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" preset in Delete Preset dialog on Create Route Group page
    Then Operator verifies "Preset \"{KEY_SHIPMENTS_FILTERS_PRESET_NAME}\" will be deleted permanently. Proceed to delete?" message is displayed in Delete Preset dialog on Create Route Group page
    When Operator clicks Delete button in Delete Preset dialog on Create Route Group page
    Then Operator verifies that warning toast displayed:
      | top    | 1 filter preset deleted               |
      | bottom | ID: {KEY_SHIPMENTS_FILTERS_PRESET_ID} |
    And DB Operator verifies "{KEY_SHIPMENTS_FILTERS_PRESET_ID}" filter preset is deleted

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Save Current As Preset button on Create Route Groups Page - Shipment Filters (uid:12b0df82-823a-4f7d-ad8b-03a397c81394)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Save Current as Preset" shipments preset action on Create Route Group page
    Then Operator verifies Save Preset dialog on Create Route Group page contains filters:
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name-3}                                                                                    |
      | Shipment Completion Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00 |
      | Shipment Status: At Transit Hub                                                                                   |
      | Shipment Type: Air Haul                                                                                           |
      | Transit Date Time: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00             |
    When Operator enters "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" Preset Name in Save Preset dialog on Create Route Group page
    Then Operator verifies help text "This name is already taken. Do you want to update this preset?" is displayed in Save Preset dialog on Create Route Group page
    When Operator clicks Update button in Save Preset dialog on Create Route Group page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                   |
      | bottom             | Name: {KEY_SHIPMENTS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                      |
    When Operator refresh page
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator verifies selected Shipment Filters on Create Route Group page:
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
  Scenario: Operator Update Existing Preset via Update Preset button on Create Route Groups Page - Shipment Filters (uid:8ea83f47-8df7-40af-af0f-1dd27283cd15)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Update Preset" shipments preset action on Create Route Group page
    Then Operator verifies that success toast displayed:
      | top                | 1 filter preset updated                   |
      | bottom             | Name: {KEY_SHIPMENTS_FILTERS_PRESET_NAME} |
      | waitUntilInvisible | true                                      |
    When Operator refresh page
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator verifies selected Shipment Filters on Create Route Group page:
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

  @DeleteRouteGroups @DeleteFilterTemplate
  Scenario: Operator Add Waypoint To Existing Route Group By Selected Filter Preset (uid:677056fa-a044-487e-8b10-f95739f8578b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator creates new Route Groups Filter Template using data below:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.orderDetailServiceTypes | PARCEL                                       |
      | value.deliveryTypeIds         | 4                                            |
      | value.showTransaction         | true                                         |
      | value.showReservations        | false                                        |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    And Operator adds following transactions to Route Group "{KEY_CREATED_ROUTE_GROUP.name}":
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    And Operator verifies selected General Filters on Create Route Group page:
      | shipper | {shipper-v4-legacy-id}-{shipper-v4-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | orderServiceType | Parcel Delivery |
      | deliveryType     | Sameday         |

  @DeleteRouteGroups @DeleteFilterTemplate
  Scenario: Operator Add Waypoint To New Route Group By Selected Filter Preset (uid:77c4ed63-51df-4998-a131-cb5cac5de236)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator creates new Route Groups Filter Template using data below:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.orderDetailServiceTypes | PARCEL                                       |
      | value.deliveryTypeIds         | 4                                            |
      | value.showTransaction         | true                                         |
      | value.showReservations        | false                                        |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator selects "{KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME}" Filter Preset on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    When Operator adds following transactions to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}":
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | PICKUP   |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    And Operator verifies selected General Filters on Create Route Group page:
      | shipper | {shipper-v4-legacy-id}-{shipper-v4-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | orderServiceType | Parcel Delivery |
      | deliveryType     | Sameday         |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op