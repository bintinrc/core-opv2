@OperatorV2 @Core @Routing  @CreateRouteGroups @CreateRouteGroupsPart2
Feature: Create Route Groups

  https://studio.cucumber.io/projects/208144/test-plan/folders/1593801

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroupsV2 @MediumPriority
  Scenario: Operator Filter Route Grouping on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214757
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    When Operator adds following transactions to new Route Group "FCRG3-{gradle-current-date-yyyyMMddHHmmsss}" on Create Route Groups page:
      | trackingId                            | type     |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | PICKUP   |
    Then Operator verifies that success react notification displayed:
      | top | Added successfully |
    When Operator refresh page
    And Operator set General Filters on Create Route Groups page:
      | creationTime  | today                                      |
      | routeGrouping | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressString} | Pending Pickup         |

  @HighPriority
  Scenario: Download CSV of Route Group Information on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5165473
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id}, "global_shipper_id":{shipper-v4-id},"pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | current hour          |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderType | Normal,Return |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationType   | Normal  |
      | reservationStatus | PENDING |
    And Operator click Load Selection on Create Route Groups page
    And Operator sort Transactions or Reservations table by Tracking ID on Create Route Groups page
    And Operator save records from Transactions or Reservations table on Create Route Groups page
    And Operator download CSV file on Create Route Groups page
    Then Operator verify Transactions or Reservations CSV file on Create Route Groups page

  @DeleteRouteGroupsV2
  Scenario: Operator Filter Route Grouping on Create Route Groups - Empty Route Group
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/7452174
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Route - create route group:
      | name        | CRG1-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime  | today                                      |
      | routeGrouping | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies results table is empty on Create Route Groups

  @DeleteFilterTemplateV2 @MediumPriority
  Scenario: Operator Filter Master Shipper by Apply Filter Preset on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/7452124
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Marketplace","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Lighthouse - creates new Route Groups Filter Template:
      | name                   | PRESET {gradle-current-date-yyyyMMddHHmmsss} |
      | value.masterShipperIds | {shipper-v4-marketplace-legacy-id}           |
      | value.showTransaction  | true                                         |
      | value.showReservation  | false                                        |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator selects "{KEY_LIGHTHOUSE_CREATED_ROUTE_GROUPS_FILTER_PRESETS[1].name}" Filter Preset on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortToAddressString}   | Pending Pickup |

  @DeleteRouteGroupsV2 @HighPriority
  Scenario: Operator Filter Route Grouping on Create Route Groups - Include Only Transactions
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/7452177
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Route - create route group:
      | name        | CRG2-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                      |
      | requestBody  | {"reservationIds":[{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}]} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                                                   |
      | requestBody  | {"transactionIds":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id},{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}]} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime  | today                                      |
      | routeGrouping | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type       | PICKUP Transaction                                          |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                              |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Pending Pickup                                            |
    Then Operator verifies Reservation records not shown on Create Route Groups page using data below:
      | id                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |

  @DeleteRouteGroupsV2 @HighPriority
  Scenario: Operator Filter Route Grouping on Create Route Groups - Include Only Reservations
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/7452193
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When API Route - create route group:
      | name        | CRG3-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                                                                                                               |
      | requestBody  | {"transactionIds":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id},{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}],"reservationIds":[{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}]} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime  | today                                      |
      | routeGrouping | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
      | shipper       | {filter-shipper-name}                      |
    And Operator choose "Hide Transactions" on Transaction Filters section on Create Route Groups page
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                                       | type        | shipper                                 | address                                                                  | status  | startDateTime                                                   | endDateTime                                                      |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} | Reservation | {KEY_LIST_OF_CREATED_ADDRESSES[1].name} | {KEY_LIST_OF_CREATED_ADDRESSES[1].to1LineShortAddressWithSpaceDelimiter} | PENDING | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedReadyDatetime} | {KEY_LIST_OF_CREATED_RESERVATIONS[1].getLocalizedLatestDatetime} |
    Then Operator verifies Transaction records not shown on Create Route Groups page using data below:
      | trackingId                                 | type                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   |

  @DeleteRouteGroupsV2 @HighPriority
  Scenario: Operator Filter Route Grouping on Create Route Groups - Include Only Shipment
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/7452194
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Shipper - Operator create new shipper address using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Core - Operator create reservation using data below:
      | reservationRequest | {"legacy_shipper_id":{shipper-v4-legacy-id},"global_shipper_id":{shipper-v4-id}, "pickup_address_id":{KEY_LIST_OF_CREATED_ADDRESSES[1].id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}","pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    And API Route - create route group:
      | name        | CRG4-{gradle-current-date-yyyyMMddHHmmsss}                                                                   |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                      |
      | requestBody  | {"reservationIds":[{KEY_LIST_OF_CREATED_RESERVATIONS[1].id}]} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                                                   |
      | requestBody  | {"transactionIds":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id},{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}]} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime  | today                                      |
      | routeGrouping | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].name} |
    And Operator choose "Include Shipments" on Shipments Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type       | PICKUP Transaction                                          |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                              |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Pending Pickup                                            |
    Then Operator verifies Reservation records not shown on Create Route Groups page using data below:
      | id                                       |
      | {KEY_LIST_OF_CREATED_RESERVATIONS[1].id} |