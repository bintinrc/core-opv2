@OperatorV2 @Core @Routing @RoutingJob1 @RouteGroupManagement
Feature: Route Group Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups @CloseNewWindows
  Scenario: Operator Creates Route Group (uid:1b4f68cf-074d-420d-9d61-cd690f47d02b)
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new route group on Route Groups Management page:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
      | hub         | {hub-name}                                                                                                   |
    Then Operator verify route group on Route Groups Management page:
      | name                 | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description          | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
      | createDateTime       | ^{gradle-current-date-yyyy-MM-dd}.*                                                                          |
      | noTransactions       | 0                                                                                                            |
      | noRoutedTransactions | 0                                                                                                            |
      | noReservations       | 0                                                                                                            |
      | noRoutedReservations | 0                                                                                                            |
      | hubName              | {hub-id} - {hub-name}                                                                                        |

  @DeleteRouteGroups
  Scenario: Operator Updates Route Group Details (uid:1eed4c03-b980-47b2-9816-8530890a996e)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator update created route group on Route Group Management page:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}-EDITED                        |
      | description | This Route Group is created by automation test from Operator V2. EDITED |
      | hubName     | {hub-name-2}                                                            |
    Then Operator verifies that success react notification displayed:
      | top                | Id: {KEY_CREATED_ROUTE_GROUP.id} |
      | bottom             | 1 Route Group Updated            |
      | waitUntilInvisible | true                             |
    Then Operator verify route group on Route Groups Management page:
      | id                   | {KEY_CREATED_ROUTE_GROUP.id}                                            |
      | name                 | ARG-{gradle-current-date-yyyyMMddHHmmsss}-EDITED                        |
      | description          | This Route Group is created by automation test from Operator V2. EDITED |
      | createDateTime       | ^{gradle-current-date-yyyy-MM-dd}.*                                     |
      | noTransactions       | 0                                                                       |
      | noRoutedTransactions | 0                                                                       |
      | noReservations       | 0                                                                       |
      | noRoutedReservations | 0                                                                       |
      | hubName              | {hub-id-2} - {hub-name-2}                                               |

  @DeleteRouteGroups
  Scenario: Operator Deletes Route Group (uid:b26dcd98-2fb0-418a-8903-ffcdf911c416)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete "{KEY_CREATED_ROUTE_GROUP.name}" route group on Route Group Management page
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_CREATED_ROUTE_GROUP.name} |
      | bottom             | 1 Route Group Deleted          |
      | waitUntilInvisible | true                           |
    Then Operator verify "{KEY_CREATED_ROUTE_GROUP.name}" route group was deleted on Route Group Management page

  @DeleteRouteGroups
  Scenario: Delete Transactions From Route Group (uid:92fed5ab-78c7-4fc8-95d3-5ea1e19f6580)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | PICKUP   |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete delivery transaction from route group:
      | name       | {KEY_CREATED_ROUTE_GROUP.name}  |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verifies that success react notification displayed:
      | top    | Id: {KEY_CREATED_ROUTE_GROUP.id} |
      | bottom | 1 Route Group Updated            |

  @DeleteRouteGroups
  Scenario: Bulk Delete Route Groups (uid:de12c7a6-b147-4303-92c2-5b4f3f9bfa0f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG1-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator create new Route Group:
      | name        | ARG2-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    When Operator delete route groups on Route Group Management page using password "1234567890":
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[2].name} |
    Then Operator verifies that success react notification displayed:
      | top                | 2 Route Group(s) Deleted |
      | waitUntilInvisible | true                     |
    And Operator verify route groups were deleted on Route Group Management page:
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[2].name} |

  @DeleteRouteGroups
  Scenario: Delete A Route Group From Edit Route Group Modal (uid:ec48ee39-3763-4341-86a7-c243b8626028)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete "{KEY_CREATED_ROUTE_GROUP.name}" route group from Edit Route Group modal on Route Group Management page
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_CREATED_ROUTE_GROUP.name} |
      | bottom             | 1 Route Group Deleted          |
      | waitUntilInvisible | true                           |
    Then Operator verify "{KEY_CREATED_ROUTE_GROUP.name}" route group was deleted on Route Group Management page

  @DeleteRouteGroups
  Scenario: Clear Transaction of Route Groups (uid:e88279e4-1a62-4306-ae40-8ddfca8584c5)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator clear selected route groups on Route Group Management page:
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route Group(s) Cleared |
      | waitUntilInvisible | true                     |
    And Operator verifies "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group was cleared on Route Group Management page

  @DeleteRouteGroups
  Scenario: Filter Route Groups Based on Creation Date (uid:bd08ae06-107e-4b82-8863-56a0d77105d6)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator apply filters on Route Group Management page:
      | fromDate | {gradle-current-date-yyyy-MM-dd} |
      | toDate   | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verifies route groups table is filtered by "^{gradle-current-date-yyyy-MM-dd}.*" date on Route Group Management page

  @DeleteRouteGroups
  Scenario: Download CSV File of Transactions of a Route Group (uid:5ba4b6f7-7af1-4bf0-8e70-d7b472870676)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator download jobs of "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group on Edit Route Group modal on Route Group Management page
    Then Operator verify route group jobs CSV file on Route Group Management page

  @DeleteRouteGroups
  Scenario: Delete Reservations From Route Group
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add Reservation to Route Group with ID = "{KEY_CREATED_ROUTE_GROUP.id}"
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete transaction from route group:
      | name | {KEY_CREATED_ROUTE_GROUP.name} |
      | id   | {KEY_CREATED_RESERVATION_ID}   |
    Then Operator verifies that success react notification displayed:
      | top    | Id: {KEY_CREATED_ROUTE_GROUP.id} |
      | bottom | 1 Route Group Updated            |
    When Operator open Edit Rout Group dialog for "{KEY_CREATED_ROUTE_GROUP.name}" route group
    Then Operator verify there is no "{KEY_CREATED_RESERVATION_ID}" transaction in Edit Rout Group dialog
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_CREATED_RESERVATION_ID} |
      | deletedAt    | not null                     |

  @DeleteRouteGroups
  Scenario: Clear Reservations of Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add Reservation to Route Group with ID = "{KEY_CREATED_ROUTE_GROUP.id}"
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator clear selected route groups on Route Group Management page:
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    Then Operator verifies that success react notification displayed:
      | top                | 1 Route Group(s) Cleared |
      | waitUntilInvisible | true                     |
    And Operator verifies "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group was cleared on Route Group Management page
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_CREATED_RESERVATION_ID} |
      | deletedAt    | not null                     |

  @DeleteRouteGroups
  Scenario: Operator Deletes Route Group with Transaction & Reservation Assigned
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
    And API Operator add Reservation to Route Group with ID = "{KEY_CREATED_ROUTE_GROUP.id}"
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete "{KEY_CREATED_ROUTE_GROUP.name}" route group on Route Group Management page
    Then Operator verifies that success react notification displayed:
      | top                | {KEY_CREATED_ROUTE_GROUP.name} |
      | bottom             | 1 Route Group Deleted          |
      | waitUntilInvisible | true                           |
    Then Operator verify "{KEY_CREATED_ROUTE_GROUP.name}" route group was deleted on Route Group Management page
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Route - verify route_groups record:
      | id        | {KEY_CREATED_ROUTE_GROUP.id} |
      | deletedAt | not null                     |
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_CREATED_RESERVATION_ID} |
      | deletedAt    | not null                     |
    And DB Route - verify route_groups_references record:
      | routeGroupId | {KEY_CREATED_ROUTE_GROUP.id} |
      | referenceId  | {KEY_TRANSACTION.id}         |
      | deletedAt    | not null                     |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op