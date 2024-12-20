@OperatorV2 @Core @Routing  @CreateRouteGroups @TransactionFiltersPart1
Feature: Create Route Groups - Transaction Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2142860

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Operator Filter Order Type on Create Route Groups - Transaction Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/5214759
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
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderType | Normal,Return |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} | {KEY_LIST_OF_CREATED_ORDERS[2].buildShortFromAddressString} | Pending Pickup         |

  @DeleteRoutes @HighPriority
  Scenario: Operator Filter RTS on Create Route Groups - Transaction Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/5214755
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
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
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
      | orderId       | {KEY_LIST_OF_CREATED_ORDERS[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type          | DELIVERY Transaction                                        |
      | shipper       | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | status        | Arrived at Sorting Hub                                      |
      | startDateTime | {gradle-next-1-day-yyyy-MM-dd} 12:00:00                     |
      | endDateTime   | {gradle-next-1-day-yyyy-MM-dd} 15:00:00                     |

  Scenario Outline: Operator Filter PP/DD Leg Transaction on Create Route Groups - Transaction Filters - PP/DD Leg = <ppDdLeg>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/6905921
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | type       | <type> Transaction                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}   |
      | address    | <address>                                  |
      | status     | Pending Pickup                             |
    Examples:
      | ppDdLeg | type     | address                                                     |
      | PP      | PICKUP   | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | DD      | DELIVERY | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   |

  Scenario Outline: Operator Filter Granular Order Status on Create Route Groups - Transaction Filters - Granular Order Status = <granularStatus>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/6905706
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                  |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | { "service_type":"<serviceType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | <granularStatus>                   |
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type       | PICKUP Transaction                                          |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
      | status     | <granularStatus>                                            |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | <granularStatus>                                          |
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

  @HighPriority
  Scenario: Operator Filter Order Zone on Create Route Groups - Transaction Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/6905747
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | zone | {KEY_SORT_ZONE_INFO.name} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
      | status     | Pending Pickup                                            |

  @HighPriority
  Scenario: Operator Filter Transaction Status on Create Route Groups - Transaction Status = Pending - Transaction Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/6905898
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
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

  Scenario: Operator Filter Transaction Status on Create Route Groups - Transaction Status = Cancelled - Transaction Filters (uid:b39eed67-342c-4738-a779-42437223eb82)
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2142860/scenarios/6905850
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                  |
      | type       | PICKUP Transaction                                          |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | type       | DELIVERY Transaction                                      |
      | shipper    | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString} |
