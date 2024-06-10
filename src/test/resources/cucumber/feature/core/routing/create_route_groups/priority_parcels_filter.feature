@OperatorV2 @Core @Routing  @CreateRouteGroups @PriorityParcelsFilter
Feature: Create Route Groups - Priority Parcel Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2142867

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario Outline: Operator Filter Service Level on Create Route Groups - <serviceLevel>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142867/scenarios/6902057
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"<serviceLevel>", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
      | serviceLevel | <serviceLevel>        |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type       | PICKUP Transaction                                          |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                              |
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Pending Pickup                                            |
    Examples:
      | serviceLevel |
      | STANDARD     |
      | NEXTDAY      |
      | SAMEDAY      |
      | EXPRESS      |

  @HighPriority
  Scenario: Operator Filter Excluded Shipper and Non Excluded Shipper on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142867/scenarios/6902146
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime    | today                                                    |
      | shipper         | {filter-shipper-name}                                    |
      | excludedShipper | {filter-shipper-name},{shipper-v4-marketplace-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies that error react notification displayed:
      | top    | Status 400: Bad Request                                                                    |
      | bottom | ^.*Error Message: Same shipper ids are both included and excluded: {filter-shipper-name}.* |

  @HighPriority
  Scenario: Operator Filter Excluded Shipper on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142867/scenarios/6902128
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime    | today                              |
      | shipper         | {filter-shipper-name}              |
      | excludedShipper | {shipper-v4-marketplace-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type       | PICKUP Transaction                                          |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                              |
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Pending Pickup                                            |

  @HighPriority
  Scenario: Operator Filter Hub Inbound Datetime with Start Datetime and End Datetime on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142867/scenarios/6968575
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | shipper                | {filter-shipper-name}            |
      | hubInboundDatetimeFrom | {gradle-current-date-yyyy-MM-dd} |
      | hubInboundDatetimeTo   | {gradle-next-1-day-yyyy-MM-dd}   |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Arrived at Sorting Hub                                    |

  @HighPriority
  Scenario: Operator Filter Hub Inbound Datetime with Order Creation Time on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142867/scenarios/6902120
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - DWS inbound V1
      | barcodes          | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}   |
      | hubId             | {hub-id}                                     |
      | dwsInboundRequest | { "dimensions": {"l":500.1,"w":220,"h":710}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime           | today                            |
      | shipper                | {filter-shipper-name}            |
      | hubInboundDatetimeFrom | {gradle-current-date-yyyy-MM-dd} |
      | hubInboundDatetimeTo   | {gradle-next-1-day-yyyy-MM-dd}   |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
    And Operator click Load Selection on Create Route Groups page
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Arrived at Sorting Hub                                    |

  @HighPriority
  Scenario: Operator Filter Original Transaction End Time on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142867/scenarios/6936912
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - get order_delivery_details record for order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime                   | today                                                                              |
      | shipper                        | {filter-shipper-name}                                                              |
      | originalTransactionEndTimeFrom | {KEY_CORE_LIST_OF_ORDER_DELIVERY_DETAILS[1].originalTransactionEndDate_yyyy_MM_dd} |
      | originalTransactionEndTimeTo   | +1 day                                                                             |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Pending Pickup |
    And Operator click Load Selection on Create Route Groups page
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Pending Pickup                                            |
