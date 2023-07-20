@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @PriorityParcelsFilter @CRG3
Feature: Create Route Groups - Priority Parcel Filters

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Service Level on Create Route Groups - <serviceLevel>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"<serviceLevel>","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
      | serviceLevel | <serviceLevel>        |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |
    Examples:
      | serviceLevel |
      | STANDARD     |
      | NEXTDAY      |
      | SAMEDAY      |
      | EXPRESS      |

  Scenario: Operator Filter Excluded Shipper and Non Excluded Shipper on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
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
      | top    | Status 400: Unknown                                                                        |
      | bottom | ^.*Error Message: Same shipper ids are both included and excluded: {filter-shipper-name}.* |

  Scenario: Operator Filter Excluded Shipper on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Hub Inbound Datetime with Start Datetime and End Datetime on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | shipper                | {filter-shipper-name}            |
      | hubInboundDatetimeFrom | {gradle-current-date-yyyy-MM-dd} |
      | hubInboundDatetimeTo   | {gradle-next-1-day-yyyy-MM-dd}   |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
    And Operator click Load Selection on Create Route Groups page
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Arrived at Sorting Hub                                   |

  Scenario: Operator Filter Hub Inbound Datetime with Order Creation Time on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":10},"dimensions":{"l":500.1,"w":220,"h":710},"hub_id":{hub-id}} |
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Arrived at Sorting Hub                                   |

  Scenario: Operator Filter Original Transaction End Time on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":10},"dimensions":{"l":500.1,"w":220,"h":710},"hub_id":{hub-id}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime                   | today                            |
      | shipper                        | {filter-shipper-name}            |
      | originalTransactionEndTimeFrom | {gradle-current-date-yyyy-MM-dd} |
      | originalTransactionEndTimeTo   | {gradle-next-1-day-yyyy-MM-dd}   |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | Arrived at Sorting Hub |
    And Operator click Load Selection on Create Route Groups page
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Arrived at Sorting Hub                                   |
