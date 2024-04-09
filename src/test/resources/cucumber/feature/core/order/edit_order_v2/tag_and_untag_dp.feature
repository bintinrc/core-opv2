@OperatorV2 @Core @EditOrderV2 @TagAndUntagDP @RoutingModules
Feature: Tag & Untag DP

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HighPriority
  Scenario: Operator Tag Order to DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "QA core api automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator tags order to "{dpms-id}" DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].toName}         |
      | email   | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}        |
      | contact | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}      |
      | address | 501, ORCHARD ROAD, SG, 238880 3-4 238880 SG SG |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ASSIGNED TO DP |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 501, ORCHARD ROAD, SG, 238880      |
      | toAddress2 | 3-4                                |
      | toPostcode | 238880                             |
      | toCity     | SG                                 |
      | toCountry  | SG                                 |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::generateOrderDataBean   |
      | seq_no   | 1                                          |
    And DB Core - verify transactions record:
      | id                    | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId            | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status                | Pending                                                    |
      | distribution_point_id | {dpms-id}                                                  |
      | address1              | 501, ORCHARD ROAD, SG, 238880                              |
      | address2              | 3-4                                                        |
      | postcode              | 238880                                                     |
      | city                  | SG                                                         |
      | country               | SG                                                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}   |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |

  @HighPriority
  Scenario: Operator Untag/Remove Order from DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "QA core api automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator tags order to "{dpms-id}" DP on Edit Order V2 page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator untags order from DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator verify order events on Edit Order V2 page using data below:
      | name               |
      | UNASSIGNED FROM DP |
      | UPDATE ADDRESS     |
      | UPDATE AV          |
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].toName}             |
      | email   | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}            |
      | contact | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}          |
      | address | 80 MANDAI LAKE ROAD Singapore Zoological 238900 SG |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | toCountry  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
    And DB Core - verify transactions record:
      | id                    | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId            | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status                | Pending                                                    |
      | distribution_point_id | null                                                       |
      | address1              | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2              | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode              | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country               | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}   |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Untag DP Order that is merged and routed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                               |
      | generateFrom        | INDEX-0                                                                                                                                                                                                                                                                                                                         |
      | generateTo          | INDEX-1                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[2]"
    And API Core - Operator tag to dp for the order:
      | request    | { "add_to_route": null, "dp_tag": { "dp_id": {dp-id}, "authorized_by": "SYSTEM_CONFIRMED", "collect_by": "{gradle-next-1-day-yyyy-MM-dd}", "dp_service_type": "NORMAL", "drop_off_on": "{gradle-next-1-day-yyyy-MM-dd}", "end_date": "{gradle-next-1-day-yyyy-MM-dd}", "reason": "Automated Semi Tagging", "should_reserve_slot": false, "skip_ATL_validation": true, "start_date": "{gradle-next-1-day-yyyy-MM-dd}" } } |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                                                                                                                                                                                                                                                       |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                                                                                                                                                                                               |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[2].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    And API Core - Operator merge routed waypoints:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator untags order from DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    And Operator unmask Edit Order V2 page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify waypoints record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status  | Routed                                                     |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo   | not null                                                   |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | type       | DD                                                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status     | Pending                                                    |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}         |
      | type       | DD                                                         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | status     | Pending                                                    |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}   |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].endTime}   |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Untag DP Order that is not merged and routed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions": {"weight": 1}, "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id-2},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator untags order from DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify waypoints record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status  | Routed                                                     |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | seqNo   | not null                                                   |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}   |

  @DeleteRouteGroupsV2 @MediumPriority
  Scenario: Untag DP Order that is merged and not routed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                    |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator tag to dp for the order:
      | request    | { "add_to_route": null, "dp_tag": { "dp_id": {dp-id-2}, "authorized_by": "SYSTEM_CONFIRMED", "collect_by": "{gradle-next-1-day-yyyy-MM-dd}", "dp_service_type": "NORMAL", "drop_off_on": "{gradle-next-1-day-yyyy-MM-dd}", "end_date": "{gradle-next-1-day-yyyy-MM-dd}", "reason": "Automated Semi Tagging", "should_reserve_slot": false, "skip_ATL_validation": true, "start_date": "{gradle-next-1-day-yyyy-MM-dd}" } } |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                                                                                                                                                                                                 |
    And API Core - Operator tag to dp for the order:
      | request    | { "add_to_route": null, "dp_tag": { "dp_id": {dp-id-2}, "authorized_by": "SYSTEM_CONFIRMED", "collect_by": "{gradle-next-1-day-yyyy-MM-dd}", "dp_service_type": "NORMAL", "drop_off_on": "{gradle-next-1-day-yyyy-MM-dd}", "end_date": "{gradle-next-1-day-yyyy-MM-dd}", "reason": "Automated Semi Tagging", "should_reserve_slot": false, "skip_ATL_validation": true, "start_date": "{gradle-next-1-day-yyyy-MM-dd}" } } |
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                                                                                                                                                                                                                                                                                                                                                                         |
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                                                                                                                                                                                                                                                                                                                                                                                 |
    And API Route - create route group:
      | name        | ARG-{uniqueString}                                                                                           |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    When API Route - add references to Route Group:
      | routeGroupId | {KEY_LIST_OF_CREATED_ROUTE_GROUPS[1].id}                                                                                   |
      | requestBody  | {"transactionIds":[{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id},{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}]} |
    And API Core - Operator merge waypoints on Zonal Routing:
      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator untags order from DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order V2 page
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UNASSIGNED FROM DP |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And DB Core - verify waypoints record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status  | Pending                                                    |
      | routeId | null                                                       |
      | seqNo   | null                                                       |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}          |
      | type       | DD                                                          |
      | waypointId | {KEY_CORE_MERGE_WAYPOINT_RESPONSE.data[1].data.waypoint_id} |
      | status     | Pending                                                     |
    And DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}          |
      | type       | DD                                                          |
      | waypointId | {KEY_CORE_MERGE_WAYPOINT_RESPONSE.data[1].data.waypoint_id} |
      | status     | Pending                                                     |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}   |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].endTime}   |

  @MediumPriority
  Scenario: Auto Untag DP Order that is Larger than SMALL
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"},"dimensions":{"weight":1,"height":1,"length":1,"width":1,"size":"SMALL"}}} |
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"},"dimensions":{"weight":100,"height":100,"length":100,"width":100,"size":"LARGE"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[2].id},"dp_id":{dp-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    # Verify 1st order is NOT untagged by DP Service
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator verify order events are not presented on Edit Order V2 page:
      | UNASSIGNED FROM DP |
    # Verify 2nd order is untagged by DP Service
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UNASSIGNED FROM DP        |
      | description | {dp-name} (id: {dpms-id}) |

  @HighPriority
  Scenario: Operator Tags Merged Unrouted Delivery Orders to DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","to":{"name": "QA core api automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator merge waypoints on Zonal Routing:
      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
    Then API Core - Operator verifies response of merge waypoint on Zonal Routing
      | expectedResponse | { "data": [ { "data": { "waypoint_id": {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}, "transaction_ids": [ {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id},{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} ]} } ] } |
      | actualResponse   | {KEY_CORE_MERGE_WAYPOINT_RESPONSE}                                                                                                                                                                                                     |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator tags order to "{dpms-id}" DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].toName}         |
      | email   | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}        |
      | contact | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}      |
      | address | 501, ORCHARD ROAD, SG, 238880 3-4 238880 SG SG |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ASSIGNED TO DP |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator verifies "Delivery" transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 501, ORCHARD ROAD, SG, 238880      |
      | toAddress2 | 3-4                                |
      | toPostcode | 238880                             |
      | toCity     | SG                                 |
      | toCountry  | SG                                 |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::generateOrderDataBean   |
      | seq_no   | 1                                          |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify transactions record:
      | id                    | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId            | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status                | Pending                                                    |
      | distribution_point_id | {dpms-id}                                                  |
      | address1              | 501, ORCHARD ROAD, SG, 238880                              |
      | address2              | 3-4                                                        |
      | postcode              | 238880                                                     |
      | city                  | SG                                                         |
      | country               | SG                                                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | txnStatus       | PENDING                                                    |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime}  |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}    |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |

  @HighPriority
  Scenario: Operator Tags Merged Routed Delivery Orders to DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"test sender name","phone_number":"+6583014912","email":"test@mail.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    When Operator merge transactions of created routes
    Then Operator verifies that success react notification displayed:
      | top    | Transactions with 1 Routes Merged        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order V2 page
    And Operator tags order to "{dpms-id}" DP on Edit Order V2 page
    And Operator waits for 5 seconds
    And Operator refresh page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order V2 page
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | {KEY_LIST_OF_CREATED_ORDERS[1].toName}         |
      | email   | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}        |
      | contact | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}      |
      | address | 501, ORCHARD ROAD, SG, 238880 3-4 238880 SG SG |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | ASSIGNED TO DP |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator verifies "Delivery" transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 501, ORCHARD ROAD, SG, 238880      |
      | toAddress2 | 3-4                                |
      | toPostcode | 238880                             |
      | toCity     | SG                                 |
      | toCountry  | SG                                 |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::generateOrderDataBean   |
      | seq_no   | 1                                          |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify transactions record:
      | id                    | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId            | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status                | Pending                                                    |
      | routeId               | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | distribution_point_id | {dpms-id}                                                  |
      | address1              | 501, ORCHARD ROAD, SG, 238880                              |
      | address2              | 3-4                                                        |
      | postcode              | 238880                                                     |
      | city                  | SG                                                         |
      | country               | SG                                                         |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | txnStatus       | PENDING                                                    |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime}  |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}    |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo    | 100                                                        |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status   | Routed                                                     |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo    | 100                                                        |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | status   | Routed                                                     |
      | address1 | 501, ORCHARD ROAD, SG, 238880                              |
      | address2 | 3-4                                                        |
      | postcode | 238880                                                     |
      | city     | SG                                                         |
      | country  | SG                                                         |
