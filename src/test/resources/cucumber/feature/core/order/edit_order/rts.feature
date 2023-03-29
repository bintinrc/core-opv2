@OperatorV2 @Core @EditOrder @RTS @EditOrder4
Feature: RTS

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @routing-refactor @happy-path
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Unrouted
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
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
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
    Then Operator verifies Zone is "{KEY_SORT_RTS_ZONE_TYPE.shortName}" on Edit Order page
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed
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
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
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
    Then Operator verifies Zone is "{KEY_SORT_RTS_ZONE_TYPE.shortName}" on Edit Order page
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Pending Reschedule, Latest Scan = Driver Inbound Scan
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
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | DRIVER INBOUND SCAN        |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
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
    Then Operator verifies Zone is "{KEY_SORT_RTS_ZONE_TYPE.shortName}" on Edit Order page
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS an Order on Edit Order Page - Pending Reschedule, Latest Scan = Hub Inbound Scan
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
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                     |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Delivery Fail" on Edit Order page
    And Operator verify order granular status is "Pending Reschedule" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | DRIVER INBOUND SCAN        |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
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
    Then Operator verifies Zone is "{KEY_SORT_RTS_ZONE_TYPE.shortName}" on Edit Order page
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Unrouted - Edit Delivery Address
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
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 116 Keng Lee Rd                |
      | address2     | 15                             |
      | postalCode   | 308402                         |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
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
    Then Operator verifies Zone is "{KEY_SORT_RTS_ZONE_TYPE.shortName}" on Edit Order page
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed - Edit Delivery Address
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
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 116 Keng Lee Rd                |
      | address2     | 15                             |
      | postalCode   | 308402                         |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id}             |
      | rts        | 1                                              |
      | toAddress1 | 116 Keng Lee Rd                                |
      | toAddress2 | 15                                             |
      | toPostcode | 308402                                         |
      | toCity     | Singapore                                      |
      | toCountry  | Singapore                                      |
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
      | address1 | 116 Keng Lee Rd                                    |
      | address2 | 15                                                 |
      | postcode | 308402                                             |
      | city     | Singapore                                          |
      | country  | Singapore                                          |
    Then DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | city     | Singapore                                                  |
      | country  | Singapore                                                  |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
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
    When DB Core - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "RTS", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies Zone is "{KEY_SORT_RTS_ZONE_TYPE.shortName}" on Edit Order page
    And DB Core - verify waypoints record:
      | id            | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  Scenario Outline: Operator RTS Order with Allowed Granular Status - <granular_status> (uid:2ce27a02-460b-40f3-91f4-e42981a6eb96)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | <granular_status>                 |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "<granular_status>" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn   | 2       |
      | delivery_status | Pending |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    When DB Operator gets waypoint record
    And API Operator get Addressing Zone from a lat long with type "RTS"
    Then Operator verifies Zone is correct after RTS on Edit Order page
    And Operator verifies waypoints.routing_zone_id is correct
    Examples:
      | granular_status         |
      | En-route to Sorting Hub |
      | Transferred to 3PL      |

  @DeleteOrArchiveRoute @routing-refactor
  Scenario: Operator RTS Order with Allowed Granular Status - On Vehicle for Delivery (uid:d56ee23a-ca14-4d91-9942-4ae1c71a49b9)
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | PENDING                |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | DRIVER INBOUND SCAN        |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "En-route to Sorting Hub" on Edit Order page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status  | FAIL                   |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    When DB Operator gets waypoint record
    And API Operator get Addressing Zone from a lat long with type "RTS"
    Then Operator verifies Zone is correct after RTS on Edit Order page
    And Operator verifies waypoints.routing_zone_id is correct

  Scenario: Operator not Allowed to RTS Order Tagged to a DP
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify menu item "Delivery" > "Return to Sender" is disabled on Edit order page

  Scenario Outline: Operator RTS Order with Active PETS Ticket Damaged/Missing - <ticketType>
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | <ticketType>       |
      | orderOutcome            | <orderOutcome>     |
      | ticketNotes             | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    And Operator RTS order on Edit Order page using data below:
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit order page using data below:
      | type               | DELIVERY                                                   |
      | status             | PENDING                                                    |
      | destinationAddress | {KEY_CREATED_ORDER.buildShortFromAddressWithCountryString} |
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    When API Operator get order details
    And Operator save the last DELIVERY transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Pending                            |
      | routeId | null                               |
      | seqNo   | null                               |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verify Jaro Scores:
      | waypointId                         | archived |
      | {KEY_TRANSACTION_AFTER.waypointId} | 1        |
    Examples:
      | ticketType | orderOutcome          |
      | MISSING    | LOST - DECLARED       |
      | DAMAGED    | NV TO REPACK AND SHIP |

  Scenario Outline: Operator RTS Order with On Hold Resolved PETS Ticket Non-Damaged/Missing - <ticketType>
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | <ticketType>       |
      | ticketSubType           | <ticketSubType>    |
      | orderOutcome            | <orderOutcome>     |
      | ticketNotes             | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When Operator updates recovery ticket on Edit Order page:
      | status  | RESOLVED       |
      | outcome | <orderOutcome> |
    And Operator refresh page
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator RTS order on Edit Order page using data below:
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                    |
      | address | {KEY_CREATED_ORDER.buildFromAddressString} |
    And Operator verify transaction on Edit order page using data below:
      | type               | DELIVERY                                                   |
      | status             | PENDING                                                    |
      | destinationAddress | {KEY_CREATED_ORDER.buildShortFromAddressWithCountryString} |
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
    When API Operator get order details
    And Operator save the last DELIVERY transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
    And DB Operator verifies waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Pending                            |
      | routeId | null                               |
      | seqNo   | null                               |
    And DB Operator verifies orders record using data below:
      | rts | 1 |
    And DB Operator verify Jaro Scores:
      | waypointId                         | archived |
      | {KEY_TRANSACTION_AFTER.waypointId} | 1        |
    Examples:
      | ticketType       | ticketSubType     | orderOutcome                |
      | SELF COLLECTION  |                   | RE-DELIVER                  |
      | SHIPPER ISSUE    | DUPLICATE PARCEL  | REPACKED/RELABELLED TO SEND |
      | PARCEL EXCEPTION | CUSTOMER REJECTED | RESUME DELIVERY             |
      | PARCEL ON HOLD   | SHIPPER REQUEST   | RESUME DELIVERY             |

  Scenario Outline: Operator Not Allowed to RTS Order With Active PETS Ticket Non-Damaged/Missing - <ticketType>
    Given Operator refresh page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator create new recovery ticket on Edit Order page:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | <ticketType>       |
      | ticketSubType           | <ticketSubType>    |
      | orderOutcome            | <orderOutcome>     |
      | ticketNotes             | GENERATED          |
    And Operator refresh page
    Then Operator verify order status is "On Hold" on Edit Order page
    And Operator verify order granular status is "On Hold" on Edit Order page
    When Operator RTS order on Edit Order page using data below:
      | timeslot | All Day (9AM - 10PM) |
    Then Operator verifies that error toast displayed:
      | top    | Network Request Error                                                                                             |
      | bottom | ^.*Error Message: An order with status 'ON_HOLD' can be RTS only when last ticket is of type DAMAGED or MISSING.* |
    And DB Operator verifies orders record using data below:
      | rts | 0 |
    Examples:
      | ticketType       | ticketSubType     | orderOutcome                |
      | SELF COLLECTION  |                   | RE-DELIVER                  |
      | SHIPPER ISSUE    | DUPLICATE PARCEL  | REPACKED/RELABELLED TO SEND |
      | PARCEL EXCEPTION | CUSTOMER REJECTED | RESUME DELIVERY             |
      | PARCEL ON HOLD   | SHIPPER REQUEST   | RESUME DELIVERY             |

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Routed - Edit Delivery Address - New Address Belongs To Standard Zone
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_BEFORE"
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
      | country      | Singapore                      |
      | city         | Singapore                      |
      | address1     | 50 Amber Rd                    |
      | postalCode   | 439888                         |
    Then Operator verifies that info toast displayed:
      | top                | 1 order(s) RTS-ed |
      | waitUntilInvisible | true              |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    When API Operator get order details
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}              |
      | waypointId | {KEY_TRANSACTION_BEFORE.waypointId} |
      | type       | DD                                  |
      | status     | Fail                                |
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | DD                                 |
      | status     | Pending                            |
      | routeId    | null                               |
      | address1   | 50 Amber Rd                        |
      | postcode   | 439888                             |
      | city       | Singapore                          |
      | country    | Singapore                          |
    And DB Operator verifies transactions after RTS
      | number_of_txn       | 3       |
      | old_delivery_status | Fail    |
      | new_delivery_status | Pending |
      | new_delivery_type   | DD      |
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    When DB Operator gets waypoint record
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    Then Operator verifies Zone is correct after RTS on Edit Order page
    And Operator verifies waypoints.routing_zone_id is correct

  @DeleteOrArchiveRoute
  Scenario: Operator RTS an Order on Edit Order Page - PPNT Tied To DP
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API DP lodge in an order to DP with ID = "{dp-id}" and Shipper Legacy ID = "{shipper-v4-legacy-id}"
    And Operator waits for 10 seconds
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup at Distribution Point" on Edit Order page
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | distribution_point_id | {dpms-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And Operator refresh page
    And Operator click Delivery -> Return to Sender on Edit Order page
    And Operator verify "Order have DP attached to Pickup Transactions, contact and address details disabled" RTS hint is displayed on Edit Order page
    And Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verifies that info toast displayed:
      | top | 1 order(s) RTS-ed |
    And Operator refresh page
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    Then Operator verify order events on Edit order page using data below:
      | name                       |
      | RTS                        |
      | UPDATE ADDRESS             |
      | UPDATE CONTACT INFORMATION |
      | UPDATE AV                  |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    When API Operator get order details
    When Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}                    |
      | waypointId | {KEY_TRANSACTION.waypointId}              |
      | type       | DD                                        |
      | status     | Pending                                   |
      | routeId    | null                                      |
      | address1   | {KEY_CREATED_ORDER_ORIGINAL.fromAddress1} |
      | address2   | {KEY_CREATED_ORDER_ORIGINAL.fromAddress2} |
      | postcode   | {KEY_CREATED_ORDER_ORIGINAL.fromPostcode} |
      | city       | {KEY_CREATED_ORDER_ORIGINAL.fromCity}     |
      | country    | {KEY_CREATED_ORDER_ORIGINAL.fromCountry}  |
    And DB Operator verifies waypoints record:
      | id       | {KEY_TRANSACTION.waypointId}              |
      | status   | Pending                                   |
      | routeId  | null                                      |
      | seqNo    | null                                      |
      | address1 | {KEY_CREATED_ORDER_ORIGINAL.fromAddress1} |
      | address2 | {KEY_CREATED_ORDER_ORIGINAL.fromAddress2} |
      | postcode | {KEY_CREATED_ORDER_ORIGINAL.fromPostcode} |
      | city     | {KEY_CREATED_ORDER_ORIGINAL.fromCity}     |
      | country  | {KEY_CREATED_ORDER_ORIGINAL.fromCountry}  |
    When DB Operator gets "{KEY_TRANSACTION.waypointId}" waypoint record
    And API Operator get Addressing Zone from a lat long with type "RTS"
    Then Operator verifies Zone is correct after RTS on Edit Order page
    And Operator verifies waypoints.routing_zone_id is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
