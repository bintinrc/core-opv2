@OperatorV2 @Core @Routing @CreateRouteGroups
Feature: Create Route Groups

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups
  Scenario: Operator Add Transaction to Route Group (uid:d23d9e3d-bc53-4a52-9388-325d803f9616)
    #Notes: Shipper create sameday parcel with OC V2
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    When Operator create new 'Route Group' on 'Route Groups Management' using data below:
      | generateName | true       |
      | hubName      | {hub-name} |
    When Operator go to menu Routing -> 2. Route Group Management
    When Operator wait until 'Route Group Management' page is loaded
    Then Operator verify new 'Route Group' on 'Route Groups Management' created successfully
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    And Operator adds following transactions to Route Group "{KEY_ROUTE_GROUP_NAME}":
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |

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
  Scenario: Operator Filter by Route Grouping on Create Route Group Page
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
      | Route Grouping | {KEY_ROUTE_GROUP_NAME} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  Scenario: Operator Filter DP Order on Route Group
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

  Scenario: Operator Filter Reservation on Route Group
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
      | id                           | type        | shipper           | address                                                | status  |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {shipper-v4-name} | {KEY_CREATED_ADDRESS.to1LineAddressWithSpaceDelimiter} | Pending |

  Scenario: Operator Filter Transaction on Route Group
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

  @Debug
  Scenario: Download CSV of Route Group Information
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op