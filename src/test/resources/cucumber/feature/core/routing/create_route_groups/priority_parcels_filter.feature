@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroupsV1.5
Feature: Create Route Groups - Priority Parcel Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Service Level on Create Route Groups - <serviceLevel> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"<serviceLevel>","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
      | serviceLevel     | <serviceLevel>                 |
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
      | serviceLevel | hiptest-uid                              |
      | STANDARD     | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | NEXTDAY      | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | SAMEDAY      | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | EXPRESS      | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |

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
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}                           |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}                           |
      | shipper          | {filter-shipper-name}                                    |
      | excludedShipper  | {filter-shipper-name},{shipper-v4-marketplace-legacy-id} |
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
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}     |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipper          | {filter-shipper-name}              |
      | excludedShipper  | {shipper-v4-marketplace-legacy-id} |
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

  Scenario: Operator Filter Hub Inbound User with Order Creation Time on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":10},"dimensions":{"l":500.1,"w":220,"h":710},"hub_id":{hub-id}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | hubInboundUser   | {vendor-name}                  |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    And Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Arrived at Sorting Hub                                   |

  Scenario: Operator Filter Hub Inbound User with Order Creation Time on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":10},"dimensions":{"l":500.1,"w":220,"h":710},"hub_id":{hub-id}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Groups' page is loaded
    And Operator removes all General Filters except following on Create Route Groups page: "Creation Time, Hub Inbound User"
    And Operator add following filters on General Filters section on Create Route Groups page:
      | Creation Time    | Today         |
      | Hub Inbound User | {vendor-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
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
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom       | {gradle-next-0-day-yyyy-MM-dd}   |
      | creationTimeTo         | {gradle-next-1-day-yyyy-MM-dd}   |
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

  Scenario: Operator Filter Hub Inbound User with Start Datetime and End Datetime on Create Route Groups
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":10},"dimensions":{"l":500.1,"w":220,"h":710},"hub_id":{hub-id}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set General Filters on Create Route Groups page:
      | startDateTimeFrom | {gradle-current-date-yyyy-MM-dd} |
      | startDateTimeTo   | {gradle-next-3-day-yyyy-MM-dd}   |
      | endDateTimeFrom   | {gradle-next-1-day-yyyy-MM-dd}   |
      | endDateTimeTo     | {gradle-next-3-day-yyyy-MM-dd}   |
      | hubInboundUser    | {vendor-name}                    |
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
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Groups' page is loaded
    And Operator removes all General Filters except following on Create Route Groups page: "Creation Time, Shipper, Hub Inbound Datetime"
    And Operator add following filters on General Filters section on Create Route Groups page:
      | Creation Time      | Today                                                                         |
      | Shipper            | {filter-shipper-name}                                                         |
      | Orig Trxn End Time | {gradle-current-date-yyyy-MM-dd} 00:00,{gradle-current-date-yyyy-MM-dd} 23:30 |
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op