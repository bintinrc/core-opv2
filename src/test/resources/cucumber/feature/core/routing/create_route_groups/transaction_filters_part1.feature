@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @TransactionFiltersPart1 @CRG6
Feature: Create Route Groups - Transaction Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Filter Order Type on Create Route Groups - Transaction Filters
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderType | Normal,Return |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter RTS on Create Route Groups - Transaction Filters
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
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    Given Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | rts | Show |
    Given Operator choose "Hide Reservations" on Reservation Filters section on Create Route Groups page
    Given Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | DELIVERY Transaction                                       |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Arrived at Sorting Hub                                     |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00                    |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00                    |

  Scenario Outline: Operator Filter PP/DD Leg Transaction on Create Route Groups - Transaction Filters - PP/DD Leg = <ppDdLeg>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | ppDdLeg | <ppDdLeg> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} |
      | type       | <type> Transaction                        |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}   |
      | address    | <address>                                 |
      | status     | Pending Pickup                            |
    Examples:
      | ppDdLeg | type     | address                                                    |
      | PP      | PICKUP   | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | DD      | DELIVERY | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   |

  Scenario Outline: Operator Filter Granular Order Status on Create Route Groups - Transaction Filters - Granular Order Status = <granularStatus>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"<serviceType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | <granularStatus>                  |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | granularOrderStatus | <granularStatus> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | <granularStatus>                                           |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | <granularStatus>                                         |
    Examples:
      | granularStatus                       | serviceType |
      | Arrived at Distribution Point        | Parcel      |
      | Arrived at Origin Hub                | Parcel      |
      | Arrived at Sorting Hub               | Parcel      |
      | Cross Border Transit                 | Parcel      |
      | En-route to Sorting Hub              | Parcel      |
      | On Hold                              | Parcel      |
      | On Vehicle for Delivery              | Parcel      |
      | Pending Pickup                       | Parcel      |
      | Pending Pickup at Distribution Point | Parcel      |
      | Pending Reschedule                   | Parcel      |
      | Pickup fail                          | Return      |
      | Staging                              | Parcel      |
      | Transferred to 3PL                   | Parcel      |
      | Van en-route to pickup               | Parcel      |

  Scenario: Operator Filter Order Zone on Create Route Group - Transaction Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address":{"address1":"501 ORCHARD ROAD","address2":"WHEELOCK PLACE","country":"SG","postcode":"238880"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | zone | {zone-full-name-3} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Transaction Status on Create Route Groups - Transaction Status = Pending - Transaction Filters (uid:4a5cc769-9638-471a-be6c-6a1b6eb5fdca)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | transactionStatus | Pending |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Transaction Status on Create Route Groups - Transaction Status = Cancelled - Transaction Filters (uid:b39eed67-342c-4738-a779-42437223eb82)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | transactionStatus | Cancelled |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op