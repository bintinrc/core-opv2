@StationManagement @COD
Feature: COD Collected and Not Collected

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Driver Collects x COD but Not Route Inbound x (uid:009c3453-5bed-446a-a8ba-d684a7f9ab93)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    When completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And verifies that the dollar amount in tile: "<TileName2>" has remained un-changed
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | <CODAmount>            |

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 1755.5    | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  Scenario Outline: Driver Collects x COD and Route Inbound y (x > y) (uid:5fb4c4d3-638d-4c28-8138-032d14fe75e6)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                       |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator verify 'Money to collect' value is "<CODBalance>" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends session incompletely for route "{KEY_CREATED_ROUTE_ID}" with reason as "Incomplete money collection"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | <CODBalance>           |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 1500         | 1000       | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  Scenario Outline: Driver Collects x COD and Route Inbound y (y > x) (uid:2ed21c73-2097-4afd-b29f-edb5a7d17514)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                       |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_CREATED_ROUTE_ID}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | <CODBalance>           |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 3000         | -500       | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |


  Scenario Outline: Driver Collects x COD and Route Inbound x (uid:093c7728-d38e-42d1-9e62-1db53fab1585)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                       |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODAmount> |
    And Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_CREATED_ROUTE_ID}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODAmount>
    And verifies that the dollar amount in tile: "<TileName2>" has increased by <CODAmount>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | Completed              |

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 1755.5    | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  Scenario Outline: View Route Manifest Page (uid:ec35f255-6e77-4eaf-a457-7dedc4366690)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    When completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName>" has increased by <CODAmount>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               |
      | {KEY_CREATED_ROUTE_ID} |
    And verifies that Route Manifest page is opened on clicking route id

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TileName                            | ModalName                           |
      | {hub-id-4} | {hub-name-4} | 1755.5    | GENERATED    | COD not collected yet from couriers | COD not collected yet from couriers |

  Scenario Outline: Driver Collects x COP but Not Route Inbound x (uid:aaec869d-7120-4b52-85c8-083a129054d7)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And verifies that the dollar amount in tile: "<TileName2>" has remained un-changed
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | <CODAmount>            |

    Examples:
      | HubId      | HubName      | CODAmount | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 125.5     | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  Scenario Outline: Driver Collects x COP and Route Inbound y (x > y) (uid:b35e0575-c1b3-4238-a9c3-79a298feefb6)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                       |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator verify 'Money to collect' value is "<CODBalance>" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends session incompletely for route "{KEY_CREATED_ROUTE_ID}" with reason as "Incomplete money collection"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | <CODBalance>           |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 1500         | 1000       | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  Scenario Outline: Driver Collects x COP and Route Inbound y (y > x) (uid:61f1d829-45f7-469d-ad43-57fe6f1ef392)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    When Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                       |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODToCollect> |
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_CREATED_ROUTE_ID}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODToCollect>
    And verifies that the dollar amount in tile: "<TileName2>" has increased by <CODToCollect>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | <CODBalance>           |

    Examples:
      | HubId      | HubName      | CODAmount | CODToCollect | CODBalance | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 2500      | 3000         | -500       | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  Scenario Outline: Driver Collects x COP and Route Inbound x (uid:47a4a0db-44b0-4231-abe6-8073d7ed40e2)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And get the dollar amount from the tile: "<TileName1>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId": <HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "<OrderStatus>" on Edit Order page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And verifies that the dollar amount in tile: "<TileName1>" has increased by <CODAmount>
    And get the dollar amount from the tile: "<TileName1>"
    And get the dollar amount from the tile: "<TileName2>"
    And Operator go to menu Inbounding -> Route Inbound
    And Operator get Route Summary Details on Route Inbound page using data below:
      | hubName      | <HubName>                       |
      | fetchBy      | FETCH_BY_TRACKING_ID            |
      | fetchByValue | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator click 'Continue To Inbound' button on Route Inbound page
    And Operator click 'I have completed photo audit' button on Route Inbound page
    And Operator scan a tracking ID of created order on Route Inbound page
    And Operator open Money Collection dialog on Route Inbound page
    And Operator submit following values on Money Collection dialog:
      | cashCollected | <CODAmount> |
    And Operator verify 'Money to collect' value is "Fully Collected" on Route Inbound page
    And Operator removes route from driver app on Route Inbound page
    And Operator ends Route Inbound session for route "{KEY_CREATED_ROUTE_ID}" on Route Inbound page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then verifies that the dollar amount in tile: "<TileName1>" has decreased by <CODAmount>
    And verifies that the dollar amount in tile: "<TileName2>" has increased by <CODAmount>
    And opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName1>"
    And verifies that a table is displayed with following columns:
      | Driver Name           |
      | Route ID              |
      | COD Amount to Collect |
    And searches for the orders in modal pop-up by applying the following filters:
      | Route ID               | Driver Name         |
      | {KEY_CREATED_ROUTE_ID} | {ninja-driver-name} |
    And verifies that the following details are displayed on the modal
      | Driver Name           | {ninja-driver-name}    |
      | Route ID              | {KEY_CREATED_ROUTE_ID} |
      | COD Amount to Collect | Completed              |

    Examples:
      | HubId      | HubName      | CODAmount | OrderStatus             | TileName1                           | ModalName                           | TileName2                   |
      | {hub-id-4} | {hub-name-4} | 125.5     | En-route to Sorting Hub | COD not collected yet from couriers | COD not collected yet from couriers | COD collected from couriers |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op