@OperatorV2 @Core @EditOrder @RTS @RTSPart1 @EditOrder4
Feature: RTS

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator RTS an Order on Edit Order page - Arrived at Sorting Hub, Delivery Unrouted
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) RTS-ed                           |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id}             |
      | rts        | 1                                              |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}   |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}   |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}   |
      | toCountry  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}    |
      | toName     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | toEmail    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}      |
      | toContact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}    |
    And DB Core - verify transactions after RTS:
      | number_of_txn   | 2                                  |
      | delivery_status | Pending                            |
      | orderId         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | routeId         | 0                                  |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify transactions record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | status   | Pending                                            |
      | routeId  | null                                               |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} (RTS)     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[2].fromEmail}          |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[2].fromContact}        |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}       |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}       |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}       |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}        |
    Then DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}               |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}               |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}               |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}                |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}               |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}               |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}               |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}                |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::rts                     |
      | seq_no   | 1                                          |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order page - Arrived at Sorting Hub, Delivery Routed
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                           |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"DELIVERY"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order V2 page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) RTS-ed                           |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id}             |
      | rts        | 1                                              |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}   |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}   |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}   |
      | toCountry  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}    |
      | toName     | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} (RTS) |
      | toEmail    | {KEY_LIST_OF_CREATED_ORDERS[2].fromEmail}      |
      | toContact  | {KEY_LIST_OF_CREATED_ORDERS[2].fromContact}    |
    And DB Core - verify transactions after RTS:
      | number_of_txn       | 3                                  |
      | orderId             | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | routeId             | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | old_delivery_status | Fail                               |
      | new_delivery_status | Pending                            |
      | new_delivery_type   | DD                                 |
    And DB Core - verify transactions record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].id} |
      | status   | Pending                                            |
      | routeId  | null                                               |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} (RTS)     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[2].fromEmail}          |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[2].fromContact}        |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}       |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}       |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}       |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}        |
    Then DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}               |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}               |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}               |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}                |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress1}               |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[2].fromAddress2}               |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[2].fromPostcode}               |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[2].fromCountry}                |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::rts                     |
      | seq_no   | 1                                          |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  Scenario: Operator RTS an Order on Edit Order page - Arrived at Sorting Hub, Delivery Unrouted - Edit Delivery Address
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator RTS order on Edit Order V2 page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 116 Keng Lee Rd                |
      | address2     | 15                             |
      | postalCode   | 308402                         |
    Then Operator verifies that success react notification displayed:
      | top                | 1 order(s) RTS-ed                           |
      | bottom             | Order {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | waitUntilInvisible | true                                        |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id}             |
      | rts        | 1                                              |
      | toAddress1 | 116 Keng Lee Rd                                |
      | toAddress2 | 15                                             |
      | toPostcode | 308402                                         |
      | toCity     | Singapore                                      |
      | toCountry  | Singapore                                      |
      | toName     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} (RTS) |
      | toEmail    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}      |
      | toContact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}    |
    And DB Core - verify transactions after RTS:
      | number_of_txn   | 2                                  |
      | delivery_status | Pending                            |
      | orderId         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | routeId         | 0                                  |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify transactions record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | status   | Pending                                            |
      | routeId  | null                                               |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[2].fromName} (RTS)     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[2].fromEmail}          |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[2].fromContact}        |
      | address1 | 116 Keng Lee Rd                                    |
      | address2 | 15                                                 |
      | postcode | 308402                                             |
      | city     | Singapore                                          |
      | country  | Singapore                                          |
    Then DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | city     | Singapore                                                  |
      | country  | Singapore                                                  |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | city     | Singapore                                                  |
      | country  | Singapore                                                  |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrdersManagerImpl::rts                     |
      | seq_no   | 1                                          |
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  Scenario: Operator not Allowed to RTS Order Tagged to a DP
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    And API DP - Operator tag order to DP:
      | request | {"order_id":{KEY_LIST_OF_CREATED_ORDERS[1].id},"dp_id":{dp-id},"drop_off_date":"{date: 0 days next, yyyy-MM-dd}"} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify menu item "Delivery" > "Return to Sender" is disabled on Edit Order V2 page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op