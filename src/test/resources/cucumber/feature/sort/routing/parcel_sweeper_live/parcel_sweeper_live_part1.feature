@Sort @Routing @ParcelSweeperLive @ParcelSweeperLivePart1
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @happy-path
  Scenario: Parcel Sweeper Live - Pending Pickup (uid:2c161a4a-6452-4c70-8fb1-1bfc8f059ba3)
    Given Operator go to menu Order -> All Orders
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {parcel-sweeper-hub-name}             |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-not-inbounded} |
      | routeId               | Error                    |
      | routeInfoColor        | {white-hex-color}        |
      | driverName            | Not Inbounded            |
      | routeDescriptionColor | {white-hex-color}        |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN       |
      | hubName | {parcel-sweeper-hub-name} |
      | hubId   | {parcel-sweeper-hub-id}   |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |

  @CloseNewWindows @happy-path @needsorttask
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt unrouted (uid:27d72aac-23ad-4111-8b9f-e2a10c727f62)
    Given Operator go to menu Order -> All Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}          |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor | {success-bg-inbound} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {blue-hex-color}               |
    Then Operator verify Next Sorting Hub on Parcel Sweeper page using data below:
      | nextSortingHub | {KEY_SORT_ZONE_INFO.shortName} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {dark-gray-hex-color}                          |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN                            |
      | hubName | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | hubId   | {KEY_LIST_OF_CREATED_ORDERS[1].hubId}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub = physical hub, route's date = today (uid:ca0f7cf5-13ac-4265-934d-052136902ec7)
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"{country}"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-jkb}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}          |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {success-bg-inbound}               |
      | routeId               | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | routeInfoColor        | {blue-hex-color}                   |
      | driverName            | {ninja-driver-name}                |
      | routeDescriptionColor | {dark-gray-hex-color}              |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {blue-hex-color}               |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {dark-gray-hex-color}                          |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 31                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN                            |
      | hubName | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | hubId   | {KEY_LIST_OF_CREATED_ORDERS[1].hubId}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub different from physical hub, route's date = today (uid:2cc6f8a6-d783-46dd-8408-19f2de63dadd)
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"{country}"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}          |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {success-bg-inbound}               |
      | routeId               | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | routeInfoColor        | {blue-hex-color}                   |
      | driverName            | {ninja-driver-name}                |
      | routeDescriptionColor | {dark-gray-hex-color}              |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {blue-hex-color}               |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ROUTES[1].hub.shortName} |
      | textColor | {dark-gray-hex-color}                         |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN                            |
      | hubName | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | hubId   | {KEY_LIST_OF_CREATED_ORDERS[1].hubId}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub = physical hub, route's date is NOT today (uid:a7076aa8-6f42-4255-b5ac-1cc0aa79e3dd)
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"{country}","latitude":{latitude},"longitude":{longitude}}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id-jkb}                          |
      | globalInboundRequest | { "hubId":{hub-id-jkb} }              |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-jkb}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {parcel-sweeper-hub-name}             |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid}                 |
      | routeId               | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | routeInfoColor        | {white-hex-color}                  |
      | driverName            | NOT ROUTED TODAY                   |
      | routeDescriptionColor | {white-hex-color}                  |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {white-hex-color}              |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {white-hex-color}                              |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN       |
      | hubName | {parcel-sweeper-hub-name} |
      | hubId   | {parcel-sweeper-hub-id}   |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - Baseline Scenarios - ddnt routed, route's hub different from physical hub, route's date is NOT today (uid:6ef626ff-51d4-456d-9fb3-b0de0714dae1)
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"{country}"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{next-1-day-yyyy-MM-dd}} 16:00:00", "dateTime": "{{next-1-day-yyyy-MM-dd}}T16:00:00+00:00"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator refresh page
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name-2}                          |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid}                 |
      | routeId               | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | routeInfoColor        | {white-hex-color}                  |
      | driverName            | NOT ROUTED TODAY                   |
      | routeDescriptionColor | {white-hex-color}                  |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {white-hex-color}              |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {hub-name} |
      | textColor | #ffffff    |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name-2}        |
      | hubId   | {hub-id-2}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @happy-path
  Scenario: Parcel Sweeper Live - RTS Order (uid:b2541a22-8243-41bf-8210-b558c83fb4be)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateTo     | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"from":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":"738078","country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}          |
    Then Operator verify RTS label on Parcel Sweeper Live page
    And Operator verify Route ID on Parcel Sweeper By Hub page using data below:
      | backgroundColor | {success-bg-inbound} |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {blue-hex-color}               |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {dark-gray-hex-color}                          |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN                            |
      | hubName | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | hubId   | {KEY_LIST_OF_CREATED_ORDERS[1].hubId}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - On Hold Order - NON-MISSING TICKET (uid:481ea9da-b9bd-4718-a73d-04fcd515f80a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | 448                                   |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | DAMAGED                               |
      | orderOutcomeName   | ORDER OUTCOME (NEW_DAMAGED)           |
      | creatorUserId      | 106307852128204474889                 |
      | creatorUserName    | Niko Susanto                          |
      | creatorUserEmail   | niko.susanto@ninjavan.co              |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor       | {error-bg-invalid} |
      | routeId               | Recovery           |
      | routeInfoColor        | {white-hex-color}  |
      | driverName            | On Hold            |
      | routeDescriptionColor | {white-hex-color}  |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | On hold |
      | granularStatus | On Hold |


  @CloseNewWindows @DeleteOrArchiveRoute @happy-path
  Scenario: Parcel Sweeper Live - On Hold Order - Resolve PENDING MISSING Ticket (uid:85edd7d1-f479-471a-bd26-563d387ca91e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"SG"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | 448                                   |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | MISSING                               |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | creatorUserId      | 106307852128204474889                 |
      | creatorUserName    | Niko Susanto                          |
      | creatorUserEmail   | niko.susanto@ninjavan.co              |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}          |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor | {success-bg-inbound} |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName      | {KEY_SORT_ZONE_INFO.name}      |
      | zoneShortName | {KEY_SORT_ZONE_INFO.shortName} |
      | textColor     | {blue-hex-color}               |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {dark-gray-hex-color}                          |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 27                                 |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator unmask edit order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | TICKET RESOLVED |
    And Operator verify order event on Edit Order V2 page using data below:
      | name    | PARCEL ROUTING SCAN                            |
      | hubName | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | hubId   | {KEY_LIST_OF_CREATED_ORDERS[1].hubId}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op