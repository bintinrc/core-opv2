@OperatorV2 @Core @Routing @CreateRouteGroups
Feature: Create Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups
  Scenario: Operator Add Transaction to Route Group (uid:d23d9e3d-bc53-4a52-9388-325d803f9616)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    And Operator adds following transactions to Route Group "{KEY_CREATED_ROUTE_GROUP.name}":
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter RTS Transaction on Route Group (uid:f712664e-dbb9-4fbe-b041-d4d6c305ff48)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator wait until 'Create Route Group' page is loaded
    Given Operator removes all General Filters except following: "Creation Time"
    Given Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    Given Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | RTS | Show |
    Given Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group page
    Given Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | id            | GET_FROM_CREATED_ORDER[1]                                  |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | PICKUP Transaction                                         |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Arrived at Sorting Hub                                     |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00                    |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00                    |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Routed Transaction on Route Group (uid:9dbd0ea4-c2f5-43cc-aaa4-86b96edf944a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Routed"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
      | Routed        | Show  |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | id            | GET_FROM_CREATED_ORDER[1]                                  |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | PICKUP Transaction                                         |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Pending Pickup                                             |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00                    |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00                    |

  @DeleteRouteGroups
  Scenario: Operator Filter by Route Grouping on Create Route Group Page (uid:ba0eaa68-b518-481c-9ac5-73d32dd5b51b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    When Operator adds following transactions to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}":
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    When Operator refresh page
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Route Grouping"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Route Grouping | {KEY_CREATED_ROUTE_GROUP.name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  Scenario: Operator Filter DP Order on Route Group (uid:3d532907-367a-40db-9b5f-021f8fa9950b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator refresh created order data
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper, DP Order"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today             |
      | Shipper       | {shipper-v4-name} |
      | DP Order      | {dp-name}         |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                     | type                 | shipper                      | address                                  | status                 |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildToAddressString} | Arrived at Sorting Hub |

  Scenario: Operator Filter Reservation on Route Group (uid:85ef9076-4721-4793-8022-ae7d451d82d5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today             |
      | Shipper       | {shipper-v4-name} |
    And Operator choose "Hide Transactions" on Transaction Filters section on Create Route Group page
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationType   | Normal  |
      | reservationStatus | Pending |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Reservation records on Create Route Group page using data below:
      | id                           | type        | shipper                    | address                                                     | status  |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING |

  Scenario: Operator Filter Transaction on Route Group (uid:30fc5e7c-b85f-4401-8d92-dcc63c07a03a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today             |
      | Shipper       | {shipper-v4-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderType | Normal,Return |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  Scenario: Download CSV of Route Group Information (uid:836c52f3-fedc-448f-b722-72389fce520b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | current hour                             |
      | Shipper       | {shipper-v4-legacy-id}-{shipper-v4-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderType | Normal,Return |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group page
    And Operator add following filters on Reservation Filters section on Create Route Group page:
      | reservationType   | Normal  |
      | reservationStatus | Pending |
    And Operator click Load Selection on Create Route Group page
    And Operator sort Transactions/Reservations table by Tracking ID on Create Route Group page
    And Operator save records from Transactions/Reservations table on Create Route Group page
    And Operator download CSV file on Create Route Group page
    Then Operator verify Transactions/Reservations CSV file on Create Route Group page

  @DeleteFilterTemplate
  Scenario: Operator Save A New Preset on Create Route Groups Page - All Search Filters (uid:3da5f28e-4c54-4988-9848-f8955fe15ed3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set General Filters on Create Route Group page:
      | startDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | startDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | endDateTimeFrom   | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | endDateTimeTo     | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | creationTimeFrom  | {gradle-next-0-day-yyyy-MM-dd}                                   |
      | creationTimeTo    | {gradle-next-1-day-yyyy-MM-dd}                                   |
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator add following filters on Transactions Filters section on Create Route Group page:
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
      | bulkyTypes          | Regular                |
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
      | lastInboundHub                 | {hub-name}                     |
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
      | Transaction Status: Forced Success                                                                                |
      | RTS: Show                                                                                                         |
      | Parcel Size: Extra Large                                                                                          |
      | Timeslots: Day                                                                                                    |
      | Delivery Type: (13) C2C 1 Day - Anytime                                                                           |
      | DNR Group: 9 - SAME DAY                                                                                           |
      | Bulky Types: Regular                                                                                              |
      | Pick Up Size: Less than 10 Parcels                                                                                |
      | Reservation Type: Hyperlocal                                                                                      |
      | Reservation Status: Success                                                                                       |
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name}                                                                                      |
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
      | transactionStatus   | Forced Success         |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
      | bulkyTypes          | Regular                |
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
  Scenario: Operator Apply Filter Preset on Create Route Groups Page - All Search Filters (uid:42c4c74c-291e-4bcf-9c8e-c9348d86ff89)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | value.bulkyTypes              | REGULAR                                      |
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
      | bulkyTypes          | Regular                |
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
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | value.bulkyTypes              | REGULAR                                      |
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Route Groups Filter Template using data below:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.isRts                   | true                                         |
      | value.bulkyTypes              | REGULAR                                      |
      | value.approxVolumeValues      | Less than 10 Parcels                         |
      | value.origHub                 | {hub-id}                                     |
      | value.destHub                 | {hub-id-2}                                   |
      | value.currHub                 | {hub-id}                                     |
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
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator add following filters on Transactions Filters section on Create Route Group page:
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
      | bulkyTypes          | Regular                |
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
      | lastInboundHub                 | {hub-name}                     |
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
      | Transaction Status: Forced Success                                                                                |
      | RTS: Show                                                                                                         |
      | Parcel Size: Extra Large                                                                                          |
      | Timeslots: Day                                                                                                    |
      | Delivery Type: (13) C2C 1 Day - Anytime                                                                           |
      | DNR Group: 9 - SAME DAY                                                                                           |
      | Bulky Types: Regular                                                                                              |
      | Pick Up Size: Less than 10 Parcels                                                                                |
      | Reservation Type: Hyperlocal                                                                                      |
      | Reservation Status: Success                                                                                       |
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name}                                                                                      |
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
      | bulkyTypes          | Regular                |
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
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Route Groups Filter Template using data below:
      | name                          | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.shipperIds              | {shipper-v4-legacy-id}                       |
      | value.isRouted                | true                                         |
      | value.masterShipperIds        | {shipper-v4-marketplace-legacy-id}           |
      | value.orderDetailServiceTypes | CORPORATE_DOCUMENT                           |
      | value.zoneIds                 | {zone-id}                                    |
      | value.isRts                   | true                                         |
      | value.bulkyTypes              | REGULAR                                      |
      | value.approxVolumeValues      | Less than 10 Parcels                         |
      | value.origHub                 | {hub-id}                                     |
      | value.destHub                 | {hub-id-2}                                   |
      | value.currHub                 | {hub-id}                                     |
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
      | shipper           | {shipper-v4-legacy-id}-{shipper-v4-name}                         |
      | routed            | Show                                                             |
      | masterShipper     | {shipper-v4-marketplace-legacy-id}-{shipper-v4-marketplace-name} |
    And Operator add following filters on Transactions Filters section on Create Route Group page:
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
      | bulkyTypes          | Regular                |
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
      | lastInboundHub                 | {hub-name}                     |
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
      | transactionStatus   | Forced Success         |
      | rts                 | Show                   |
      | parcelSize          | Extra Large            |
      | timeslots           | Day                    |
      | deliveryType        | C2C 1 Day - Anytime    |
      | dnrGroup            | SAME DAY               |
      | bulkyTypes          | Regular                |
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
  Scenario: Operator Save A New Preset on Create Route Groups Page - Shipment Filters (uid:a1be140c-623f-4d2a-9ec8-2afc56d2ac93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set Shipment Filters on Create Route Group page:
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
    And Operator selects "Save Current as Preset" shipments preset action on Create Route Group page
    Then Operator verifies Save Preset dialog on Create Route Group page contains filters:
      | Shipment Date: {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00                 |
      | ETA (Date Time): {gradle-next-0-day-yyyy-MM-dd} 00:00:00 to {gradle-next-0-day-yyyy-MM-dd} 00:00:00               |
      | Start Hub: {hub-name}                                                                                             |
      | End Hub: {hub-name-2}                                                                                             |
      | Last Inbound Hub: {hub-name}                                                                                      |
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
      | lastInboundHub                 | {hub-name}                     |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteFilterTemplate
  Scenario: Operator Apply Filter Preset on Create Route Groups Page - Shipment Filters (uid:76592ef5-4801-49a6-8429-7224a6896a5b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.origHub        | {hub-id}                                     |
      | value.destHub        | {hub-id-2}                                   |
      | value.currHub        | {hub-id}                                     |
      | value.shipmentStatus | AT_TRANSIT_HUB                               |
      | value.shipmentType   | AIR_HAUL                                     |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator selects "{KEY_SHIPMENTS_FILTERS_PRESET_NAME}" shipments Filter Preset on Create Route Group page
    And Operator verifies selected Shipment Filters on Create Route Group page:
      | startHub       | {hub-name}     |
      | endHub         | {hub-name-2}   |
      | lastInboundHub | {hub-name}     |
      | shipmentStatus | At Transit Hub |
      | shipmentType   | Air Haul       |

  @DeleteFilterTemplate
  Scenario: Operator Delete Preset on Create Route Groups Page - Shipment Filters (uid:67fd041a-384e-419e-a965-e95e04da545f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator creates new Shipments Filter Template using data below:
      | name                 | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.origHub        | {hub-id}                                     |
      | value.destHub        | {hub-id-2}                                   |
      | value.currHub        | {hub-id}                                     |
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
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | lastInboundHub                 | {hub-name}                     |
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
      | Last Inbound Hub: {hub-name}                                                                                      |
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
      | lastInboundHub                 | {hub-name}                     |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  @DeleteFilterTemplate
  Scenario: Operator Update Existing Preset via Update Preset button on Create Route Groups Page - Shipment Filters (uid:8ea83f47-8df7-40af-af0f-1dd27283cd15)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | lastInboundHub                 | {hub-name}                     |
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
      | lastInboundHub                 | {hub-name}                     |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentStatus                 | At Transit Hub                 |
      | shipmentType                   | Air Haul                       |
      | transitDateTimeFrom            | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo              | {gradle-next-0-day-yyyy-MM-dd} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today             |
      | Shipper       | {shipper-v4-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | Note   | service_type    | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                   | hiptest-uid                              |
      | Parcel | Parcel Delivery | Pending Pickup | DELIVERY Transaction | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} | uid:547bc7e9-1432-4d1f-8ea8-553086758134 |
      | Return | Return          | Pending Pickup | DELIVERY Transaction | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}}  | uid:fc3a7a68-feb0-4540-9599-5b957ed37047 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Marketplace (uid:d7067f43-f02c-4dde-ba64-1aea558fed8c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | hiptest-uid                              |
      | Marketplace  | Pending Pickup | DELIVERY Transaction | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} | uid:3f17fe40-7fb8-44f5-ae5e-86639de78feb |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - International (uid:30d34cc1-76db-4833-b434-0f06294cb5a3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                |
      | v4OrderRequest | <v4OrderRequest> |
      | addressType    | global           |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type  | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                        |
      | International | Pending Pickup | DELIVERY Transaction | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"import"}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Marketplace International (uid:f8929f70-3e18-4be8-b490-20dd32b97e68)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                |
      | v4OrderRequest | <v4OrderRequest> |
      | addressType    | global           |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type              | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | Marketplace International | Pending Pickup | DELIVERY Transaction | {"service_type": "Marketplace International","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": false,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}, "international":{"portation":"import"}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Ninja Pack (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator generate 2 Ninja Pack Tracking Id
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 1                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                 | hiptest-uid                              |
      | Ninja Pack   | Pending Pickup | DELIVERY Transaction | { "requested_tracking_number":"{KEY_NINJA_PACK_TRACKING_LIST[1].trackingId}","service_type":"Ninja Pack","service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} | uid:b2314731-a6d8-42e1-9f22-4b93dfbd88e9 |

  @DeleteRouteGroups @DeleteFilterTemplate
  Scenario: Operator Add Waypoint To Existing Route Group By Selected Filter Preset (uid:677056fa-a044-487e-8b10-f95739f8578b)
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
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    And Operator verifies selected General Filters on Create Route Group page:
      | shipper | {shipper-v4-legacy-id}-{shipper-v4-name} |
    And Operator verifies selected Transactions Filters on Create Route Group page:
      | orderServiceType | Parcel Delivery |
      | deliveryType     | Sameday         |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - <service_type> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today             |
      | Shipper       | {shipper-v4-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                     | hiptest-uid                              |
      | Document     | Pending Pickup | DELIVERY Transaction | { "service_type":"Document", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} | uid:7cc4e8fa-9506-4f91-b2f2-07fbe1820b97 |

  Scenario: Operator Filter Order by Service Type on Create Route Group Page - Marketplace Sort (uid:e49e7cbc-d702-43cf-bc49-05201f83b8e1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-marketplace-sort-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Master Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time  | Today                                   |
      | Master Shipper | {shipper-v4-marketplace-sort-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | Marketplace Sort |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - <serviceType> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                                       |
      | Shipper       | {shipper-v4-corporate-subshipper-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType        | hiptest-uid                              |
      | Corporate          | uid:e9550294-1f8b-4e43-a7ec-234239ab9d67 |
      | Corporate Return   | uid:26f1fb1c-23d5-4126-8285-c325f0e7b838 |
      | Corporate Document | uid:8670e666-5a26-4450-aa4f-e00acd7472d5 |

  Scenario: Operator Filter Order by Service Type on Create Route Group Page - Corporate AWB (uid:599a191b-43b6-45ca-896e-c91e159d8f4f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator generate 2 Corporate AWB Tracking Id
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Corporate AWB","requested_tracking_number":"{KEY_CORPORATE_AWB_TRACKING_LIST[1].trackingId}","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Corporate AWB","requested_tracking_number":"{KEY_CORPORATE_AWB_TRACKING_LIST[2].trackingId}","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                                       |
      | Shipper       | {shipper-v4-corporate-subshipper-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | Corporate Manual AWB |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op