@OperatorV2 @Core @Routing @RoutingJob1 @RouteGroupManagement @RouteGroupManagementPart1
Feature: Route Group Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups @CloseNewWindows
  Scenario: Operator Creates Route Group
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
  Scenario: Operator Updates Route Group Details
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
  Scenario: Operator Deletes Route Group
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
  Scenario: Delete Transactions From Route Group
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
  Scenario: Bulk Delete Route Groups
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
  Scenario: Delete A Route Group From Edit Route Group Modal
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
