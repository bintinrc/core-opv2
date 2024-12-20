@OperatorV2 @Core @Routing @RouteGroupManagement @RouteGroupManagementPart1
Feature: Route Group Management

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroupsV2 @CloseNewWindows @MediumPriority
  Scenario: Operator Creates Route Group
    Given Operator go to menu Routing -> 2. Route Group Management
    When Operator create new route group on Route Groups Management page:
      | name        | RGM1-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
      | hub         | {hub-name}                                                                                                   |
    And Operator apply filters on Route Group Management page:
      | fromDate | {gradle-current-date-yyyy-MM-dd} |
      | toDate   | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verify route group on Route Groups Management page:
      | name                 | RGM1-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description          | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
      | createDateTime       | ^{gradle-current-date-yyyy-MM-dd}.*                                                                          |
      | noTransactions       | 0                                                                                                            |
      | noRoutedTransactions | 0                                                                                                            |
      | noReservations       | 0                                                                                                            |
      | noRoutedReservations | 0                                                                                                            |
      | hubName              | {hub-id} - {hub-name}                                                                                        |

  @DeleteRouteGroupsV2 @MediumPriority
  Scenario: Operator Updates Route Group Details
    And API Route - create route group:
      | name        | RGM2-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator update created route group on Route Group Management page:
      | name              | RGM2-{gradle-current-date-yyyyMMddHHmmsss}-EDITED                       |
      | oldRouteGroupName | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}                              |
      | description       | This Route Group is created by automation test from Operator V2. EDITED |
      | hubName           | {hub-name}                                                              |
    Then Operator verifies that success react notification displayed:
      | top    | Id: {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id} |
      | bottom | 1 Route Group Updated                        |
    Then Operator verify route group on Route Groups Management page:
      | id                   | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                |
      | name                 | RGM2-{gradle-current-date-yyyyMMddHHmmsss}-EDITED                       |
      | description          | This Route Group is created by automation test from Operator V2. EDITED |
      | createDateTime       | ^{gradle-current-date-yyyy-MM-dd}.*                                     |
      | noTransactions       | 0                                                                       |
      | noRoutedTransactions | 0                                                                       |
      | noReservations       | 0                                                                       |
      | noRoutedReservations | 0                                                                       |
      | hubName              | {hub-id} - {hub-name}                                                   |

  @DeleteRouteGroupsV2 @MediumPriority
  Scenario: Operator Deletes Route Group
    And API Route - create route group:
      | name        | RGM3-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group on Route Group Management page
    Then Operator verifies that success react notification displayed:
      | top    | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | bottom | 1 Route Group Deleted                      |
    When Operator waits for 3 seconds
    Then Operator verify "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group was deleted on Route Group Management page

  @DeleteRouteGroupsV2 @HighPriority
  Scenario: Delete Transactions From Route Group
    And API Route - create route group:
      | name        | RGM4-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Route - Operator add transactions to "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}":
      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete delivery transaction from route group:
      | name       | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}      |
    Then Operator verifies that success react notification displayed:
      | top    | Id: {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id} |
      | bottom | 1 Route Group Updated                        |

  @DeleteRouteGroupsV2 @MediumPriority
  Scenario: Bulk Delete Route Groups
    And API Route - create route group:
      | name        | RGM5-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Route - create route group:
      | name        | RMG6-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    When Operator delete route groups on Route Group Management page using password "1234567890":
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[2].name} |
    Then Operator verifies that success react notification displayed:
      | top | 2 Route Group(s) Deleted |
    When Operator waits for 3 seconds
    And Operator verify route groups were deleted on Route Group Management page:
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[2].name} |

  @DeleteRouteGroupsV2 @MediumPriority
  Scenario: Delete A Route Group From Edit Route Group Modal
    And API Route - create route group:
      | name        | RGM7-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 2. Route Group Management
    And Operator delete "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group from Edit Route Group modal on Route Group Management page
    Then Operator verifies that success react notification displayed:
      | top    | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | bottom | 1 Route Group Deleted                      |
    When Operator waits for 3 seconds
    Then Operator verify "{KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name}" route group was deleted on Route Group Management page
