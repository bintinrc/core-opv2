@StationManagement @COD
Feature: COD Collected and Not Collected

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Driver Collects x COD but Not Route Inbound x (uid:009c3453-5bed-446a-a8ba-d684a7f9ab93)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | <CODAmount>                        |

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 1755.5    | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Driver Collects x COD and Route Inbound y (x > y) (uid:5fb4c4d3-638d-4c28-8138-032d14fe75e6)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                                  |
      | fetchBy      | FETCH_BY_TRACKING_ID                       |
      | fetchByValue | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator verify 'Money to collect' value is "<CODBalance>" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends session incompletely for route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with reason as "Incomplete money collection"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | <CODBalance>                       |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 1500         | 1000       | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Driver Collects x COD and Route Inbound y (y > x) (uid:2ed21c73-2097-4afd-b29f-edb5a7d17514)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                                  |
      | fetchBy      | FETCH_BY_TRACKING_ID                       |
      | fetchByValue | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | <CODBalance>                       |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 3000         | -500       | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @Happypath @ForceSuccessOrder @ArchiveRouteCommonV2 @HighPriority
  Scenario Outline: Driver Collects x COD and Route Inbound x (uid:093c7728-d38e-42d1-9e62-1db53fab1585)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                                  |
      | fetchBy      | FETCH_BY_TRACKING_ID                       |
      | fetchByValue | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODAmount> |
    And Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODAmount>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has increased by <CODAmount>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | Completed                          |

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 1755.5    | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @ForceSuccessOrder @ArchiveRouteCommonV2
  Scenario Outline: View Route Manifest Page (uid:ec35f255-6e77-4eaf-a457-7dedc4366690)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    When API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <HubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName>" has increased by <CODAmount>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies that Route Manifest page is opened on clicking route id

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TileName                            | ModalName                           |
      | {hub-id-4} | {hub-name-4} | 1755.5    | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Driver Collects x COP but Not Route Inbound x (uid:aaec869d-7120-4b52-85c8-083a129054d7)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                          |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                                  |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS","cod":<CODAmount>}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                                           |
      | jobAction  | SUCCESS                                                                                                                                     |
      | jobMode    | PICK_UP                                                                                                                                     |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has remained un-changed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | <CODAmount>                        |

    Examples:
      | HubId      | HubName      | CODAmount | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 125.5     | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Driver Collects x COP and Route Inbound y (x > y) (uid:b35e0575-c1b3-4238-a9c3-79a298feefb6)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                          |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                                  |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS","cod":<CODAmount>}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                                           |
      | jobAction  | SUCCESS                                                                                                                                     |
      | jobMode    | PICK_UP                                                                                                                                     |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                                  |
      | fetchBy      | FETCH_BY_TRACKING_ID                       |
      | fetchByValue | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator verify 'Money to collect' value is "<CODBalance>" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends session incompletely for route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with reason as "Incomplete money collection"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | <CODBalance>                       |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 1500         | 1000       | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Driver Collects x COP and Route Inbound y (y > x) (uid:61f1d829-45f7-469d-ad43-57fe6f1ef392)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                          |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                                  |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS","cod":<CODAmount>}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                                           |
      | jobAction  | SUCCESS                                                                                                                                     |
      | jobMode    | PICK_UP                                                                                                                                     |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                                  |
      | fetchBy      | FETCH_BY_TRACKING_ID                       |
      | fetchByValue | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | <CODBalance>                       |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 3000         | -500       | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @ForceSuccessOrder @ArchiveRouteCommonV2 @MediumPriority
  Scenario Outline: Driver Collects x COP and Route Inbound x (uid:47a4a0db-44b0-4231-abe6-8073d7ed40e2)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the dollar amount from the tile: "<TileName1>"
    When API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                            |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                                                                    |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","shipper_id":{shipper-v4-legacy-id}, "action": "SUCCESS","cod":<CODAmount>}]}] |
      | routes     | KEY_DRIVER_ROUTES                                                                                                                             |
      | jobAction  | SUCCESS                                                                                                                                       |
      | jobMode    | PICK_UP                                                                                                                                       |
    And Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And Operator get the dollar amount from the tile: "<TileName1>"
    And Operator get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                                  |
      | fetchBy      | FETCH_BY_TRACKING_ID                       |
      | fetchByValue | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODAmount> |
    And Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODAmount>
    And Operator verifies that the dollar amount in tile: "<TileName2>" has increased by <CODAmount>
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And Operator verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Route ID                           | Driver Name         |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {ninja-driver-name} |
    And Operator verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}                |
      | Route ID              | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | COD Amount to Collect | Completed                          |

    Examples:
      | HubId      | HubName      | CODAmount | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 125.5     | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op