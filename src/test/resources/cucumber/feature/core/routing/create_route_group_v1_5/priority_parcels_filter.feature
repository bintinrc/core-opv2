@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroupsV1.5
Feature: Create Route Groups V1.5 - Priority Parcel Filters

  @LaunchBrowser @ShouldAlwaysRun @Debug
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Service Level on Create Route Group V1.5 - <serviceLevelUi> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"<serviceLevel>","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper, Service Level"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
      | Service Level | <serviceLevelUi>      |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    And Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |
    Examples:
      | serviceLevel | serviceLevelUi | hiptest-uid                              |
      | Standard     | Standard       | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | Nextday      | Next Day       | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | Sameday      | Same Day       | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | Express      | Express        | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |

  Scenario: Operator Filter Excluded Shipper and Non Excluded Shipper on Create Route Group V1.5
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Shipper, Excluded Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Shipper          | {filter-shipper-name}                                    |
      | Excluded Shipper | {filter-shipper-name},{shipper-v4-marketplace-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                      |
      | bottom | ^.*Error Message: Same shipper ids are both included and excluded: {filter-shipper-name}.* |

  @Debug
  Scenario: Operator Filter Excluded Shipper on Create Route Group V1.5
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-marketplace-client-id}                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-marketplace-client-secret}                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper, Excluded Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time    | Today                              |
      | Shipper          | {filter-shipper-name}              |
      | Excluded Shipper | {shipper-v4-marketplace-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    And Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op