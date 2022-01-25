@OperatorV2 @Core @Routing @RoutingJob2 @CreateRouteGroupsV1.5
Feature: Create Route Groups V1.5 - Transaction Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Filter Order Type on Create Route Group V1.5 - Transaction Filters (uid:30fc5e7c-b85f-4401-8d92-dcc63c07a03a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator add following filters on Transactions Filters section on Create Route Group V1.5 page:
      | orderType | Normal,Return |
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction records on Create Route Group V1.5 page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter RTS on Create Route Group V1.5 - Transaction Filters (uid:f712664e-dbb9-4fbe-b041-d4d6c305ff48)
    Given Operator go to menu Utilities -> QRCode Printing
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
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time"
    Given Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today |
    Given Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    Given Operator add following filters on Transactions Filters section on Create Route Group V1.5 page:
      | RTS | Show |
    Given Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group V1.5 page
    Given Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | DELIVERY Transaction                                       |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Arrived at Sorting Hub                                     |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00                    |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00                    |

  Scenario Outline: Operator Filter PP/DD Leg Transaction on Create Route Group V1.5 - Transaction Filters - PP/DD Leg = <ppDdLeg> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    Given Operator add following filters on Transactions Filters section on Create Route Group V1.5 page:
      | ppDdLeg | <ppDdLeg> |
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} |
      | type       | <type> Transaction                        |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}   |
      | address    | <address>                                 |
      | status     | Pending Pickup                            |
    Examples:
      | ppDdLeg | type     | address                                                    | hiptest-uid                              |
      | PP      | PICKUP   | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | DD      | DELIVERY | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | uid:a11f812d-673d-4215-991b-db42b3e7daa1 |

  Scenario Outline: Operator Filter Granular Order Status on Create Route Group V1.5 - Transaction Filters - Granular Order Status = <granularStatus> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"<serviceType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | <granularStatus>                  |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    Given Operator add following filters on Transactions Filters section on Create Route Group V1.5 page:
      | granularOrderStatus | <granularStatus> |
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | <granularStatus>                                           |
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | <granularStatus>                                         |
    Examples:
      | granularStatus                       | serviceType | hiptest-uid                              |
      | Arrived at Distribution Point        | Parcel      | uid:c30061fd-799c-4768-9d02-27600891f50d |
      | Arrived at Origin Hub                | Parcel      | uid:fb3817dd-c7c2-4ae9-ac27-78ae10a5dc99 |
      | Arrived at Sorting Hub               | Parcel      | uid:0fc6e89d-eeaf-4bca-b5b4-ea548affdeec |
      | Cross Border Transit                 | Parcel      | uid:b798a0b0-8d01-497d-853f-3cdf98733ab3 |
      | En-route to Sorting Hub              | Parcel      | uid:da90d5f4-0ee5-4cb3-bb2d-93e0d42b2b32 |
      | On Hold                              | Parcel      | uid:994c030d-acfc-4c0d-9cb8-c01f1533c4e2 |
      | On Vehicle for Delivery              | Parcel      | uid:bbf34aa3-1bca-4d5f-84c8-f2bae09c0365 |
      | Pending Pickup                       | Parcel      | uid:0528a079-eb73-4c63-a8d3-3c177772e569 |
      | Pending Pickup at Distribution Point | Parcel      | uid:f35f330a-96bb-4ca3-9ecc-99dbbe8f9b68 |
      | Pending Reschedule                   | Parcel      | uid:3b85490c-e3f4-453d-8ced-b2e65857bd4f |
      | Pickup fail                          | Return      | uid:c82bb52e-088d-43ef-81ee-cb8ab7d4ad99 |
      | Staging                              | Parcel      | uid:2ed012c6-d7a2-46e7-9ce9-256efe6d1c41 |
      | Transferred to 3PL                   | Parcel      | uid:e3b28ae3-5cc2-4a69-b5da-0c8a5f3c3a56 |
      | Van en-route to pickup               | Parcel      | uid:e5c5048d-2823-4521-a054-4b81033c1d72 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op