@Sort @Routing @ParcelSweeperLive @ParcelSweeperLivePart4
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - En-route to Sorting Hub (uid:dfd67099-90ac-4aa2-8260-e9a485375789)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    And API Core - Operator rts order:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                         |
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And Operator refresh page
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
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
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Arrived at Sorting Hub (uid:950ce819-726b-4d09-8cb8-a5865d5e2444)
    Given Operator go to menu Order -> All Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"SG"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
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
      | name    | PARCEL ROUTING SCAN                            |
      | hubName | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | hubId   | {KEY_LIST_OF_CREATED_ORDERS[1].hubId}          |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Staging (uid:c8c876b2-1936-45e0-af30-f0566acdfa8b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "is_staged":true, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
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
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Staging |
      | granularStatus | Staging |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Sweeper Live - Arrived at Distribution Point (uid:23438c9b-a05a-4e04-a413-78e73a8b61e6)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
#    Given Operator go to menu Distribution Points -> DP Tagging
#    When Operator tags single order to DP with DPMS ID = "{dpms-id}" and tracking id = "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
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
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                    |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                            |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                     |
      | jobType    | TRANSACTION                                                                           |
      | jobAction  | SUCCESS                                                                               |
      | jobMode    | DELIVERY                                                                              |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
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
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                       |
      | granularStatus | Arrived at Distribution Point |

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - Pending Pickup At Distribution Point (uid:3d82a836-9d71-4bd4-b624-4c9df80a26b1)
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API DP - DP user authenticate with username "{dp-user-username}" password "{dp-user-password}" and dp id "{dp-id}"
    And DB Core - Operator generate stamp id for "1" orders
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given API DP - DP Lodge-in Fully Integrated Return Order:
      | request | { "dp_id":{dp-id} , "receipt_id": 454033, "stamp_id": "{KEY_CORE_LIST_OF_CREATED_STAMP_ID[1]}", "from_name": "QASORTAUTOMATION", "from_contact": "+628176586525", "from_email": "qa.sort@gmail.com", "shipper_id": {shipper-v4-legacy-id}, "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "order_id": {KEY_LIST_OF_CREATED_ORDERS[1].id}, "to_name": "QASORTto", "to_email": "QASORTto@gmail.com", "to_contact": "+628176586525", "to_address1": "Jalan Danau Bawah No 26", "to_address2": "Tanah Abang", "to_city": "city", "to_postcode": 310205 } |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {hub-name}                            |
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
      | name    | PARCEL ROUTING SCAN |
      | hubName | {hub-name}          |
      | hubId   | {hub-id}            |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending                              |
      | granularStatus | Pending Pickup at Distribution Point |

  @CloseNewWindows
  Scenario: Parcel Sweeper Live - PRIOR Tag (uid:1becf42f-49a8-47f6-8cb8-a808abb4f9f3)
    Given Operator go to menu Order -> All Orders
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":310205,"country":"SG"}}} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - Operator bulk tags parcel with below tag:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | orderTag | 5570                               |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
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
    #When DB Sort - get next sorting task
     # | zoneName   | {KEY_SORT_ZONE_INFO.name} |
    # | sourceName | {hub-name}                    |
    #Then Operator verify Next Sorting Hub on Parcel Sweeper page using data below:
     # | nextSortingHub | {KEY_SORT_NEXT_SORT_TASK} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | textColor | {dark-gray-hex-color}                          |
    Then Operator verify Prior tag on Parcel Sweeper Live page
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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op