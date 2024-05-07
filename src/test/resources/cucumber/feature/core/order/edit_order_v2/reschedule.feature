@OperatorV2 @Core @EditOrderV2 @Reschedule
Feature: Reschedule

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2 @HighPriority @update-status
  Scenario: Operator Reschedule Fail Pickup
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                      |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pickup fail |
      | granularStatus | Pickup fail |
#    And Operator verify order events on Edit Order V2 page using data below:
#      | tags          | name          | description                                                                                                                                                                                                      |
#      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Fail Old Granular Status: Van en-route to pickup New Granular Status: Pickup fail Old Order Status: Transit New Order Status: Pickup fail Reason: BATCH_POD_UPDATE |
#    And DB Routing Search - verify transactions record:
#      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id} |
#      | txnType        | PICKUP                                             |
#      | txnStatus      | FAIL                                               |
#      | dnrId          | 2                                                  |
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
#      | granularStatus | Pickup fail                                        |
#    And DB Routing Search - verify transactions record:
#      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
#      | txnType        | DELIVERY                                           |
#      | txnStatus      | PENDING                                            |
#      | dnrId          | 0                                                  |
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
#      | granularStatus | Pickup fail                                        |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Pickup on Edit Order V2 page:
      | senderName    | test sender name               |
      | senderContact | +9727894434                    |
      | senderEmail   | test@mail.com                  |
      | pickupDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | 9AM - 12PM                     |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name       |
      | RESCHEDULE |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Fail New Pickup Status: Pending Old Granular Status: Pickup fail New Granular Status: Pending Pickup Old Order Status: Pickup fail New Order Status: Pending Reason: RESCHEDULE_ORDER |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[2].id}           |
      | rts          | 0                                            |
      | fromAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | fromAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | fromPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | fromCountry  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
      | fromName     | test sender name                             |
      | fromEmail    | test@mail.com                                |
      | fromContact  | +9727894434                                  |
    And DB Core - verify number of transactions is correct after new transactions created
      | order_id               | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | number_of_transactions | 3                                                                                                                                                                                  |
      | number_of_pickup_txn   | 2                                                                                                                                                                                  |
      | pickup_address         | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry} |
      | number_of_delivery_txn | 1                                                                                                                                                                                  |
    And DB Core - verify transactions record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | status   | Pending                                            |
      | routeId  | null                                               |
      | name     | test sender name                                   |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}       |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}       |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}       |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}        |
    Then DB Route - verify waypoints record:
      | legacyId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo         | null                                                       |
      | routeId       | null                                                       |
      | status        | Pending                                                    |
      | address1      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1}               |
      | address2      | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2}               |
      | postcode      | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode}               |
      | country       | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}                |
      | routingZoneId | 1399                                                       |
      | latitude      | 1.30706095410839                                           |
      | longitude     | 103.830899303793                                           |
    And DB Core - operator verify orders.data.previousPickupDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}           |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}  |
      | comments | OrderHelper::saveWaypoint                    |
      | seq_no   | 1                                            |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_OLD_TRANSACTION"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_NEW_TRANSACTION"
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_PP_NEW_TRANSACTION.id}                |
      | txnType         | PICKUP                                     |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_PP_NEW_TRANSACTION.startTime}         |
      | endTimeCustom   | {KEY_PP_NEW_TRANSACTION.endTime}           |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[3].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[3].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[3].endTime}   |

  @ArchiveRouteCommonV2 @MediumPriority @update-status
  Scenario: Operator Reschedule Fail Pickup - Change Pickup Address
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                      |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pickup fail |
      | granularStatus | Pickup fail |
#    And Operator verify order events on Edit Order V2 page using data below:
#      | tags          | name          | description                                                                                                                                                                                                      |
#      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Pending New Pickup Status: Fail Old Granular Status: Van en-route to pickup New Granular Status: Pickup fail Old Order Status: Transit New Order Status: Pickup fail Reason: BATCH_POD_UPDATE |
#    And DB Routing Search - verify transactions record:
#      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].id} |
#      | txnType        | PICKUP                                             |
#      | txnStatus      | FAIL                                               |
#      | dnrId          | 2                                                  |
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
#      | granularStatus | Pickup fail                                        |
#    And DB Routing Search - verify transactions record:
#      | txnId          | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
#      | txnType        | DELIVERY                                           |
#      | txnStatus      | PENDING                                            |
#      | dnrId          | 0                                                  |
#      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}         |
#      | granularStatus | Pickup fail                                        |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Pickup on Edit Order V2 page:
      | senderName    | test sender name               |
      | senderContact | +9727894434                    |
      | senderEmail   | test@mail.com                  |
      | pickupDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | 9AM - 12PM                     |
      | country       | Singapore                      |
      | city          | Singapore                      |
      | address1      | 8A MARINA BOULEVARD            |
      | address2      | MARINA BAY LINK MALL           |
      | postalCode    | 018984                         |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | RESCHEDULE     |
      | UPDATE ADDRESS |
      | UPDATE AV      |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                              |
      | MANUAL ACTION | UPDATE STATUS | Old Pickup Status: Fail New Pickup Status: Pending Old Granular Status: Pickup fail New Granular Status: Pending Pickup Old Order Status: Pickup fail New Order Status: Pending Reason: RESCHEDULE_ORDER |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts          | 0                                  |
      | fromAddress1 | 8A MARINA BOULEVARD                |
      | fromAddress2 | MARINA BAY LINK MALL               |
      | fromPostcode | 018984                             |
      | fromCountry  | Singapore                          |
      | fromCity     | Singapore                          |
      | fromName     | test sender name                   |
      | fromEmail    | test@mail.com                      |
      | fromContact  | +9727894434                        |
    And DB Core - verify number of transactions is correct after new transactions created
      | order_id               | {KEY_LIST_OF_CREATED_ORDERS[1].id}                        |
      | number_of_transactions | 3                                                         |
      | number_of_pickup_txn   | 2                                                         |
      | pickup_address         | 8A MARINA BOULEVARD MARINA BAY LINK MALL 018984 Singapore |
      | number_of_delivery_txn | 1                                                         |
    And DB Core - verify transactions record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | status   | Pending                                            |
      | routeId  | null                                               |
      | name     | test sender name                                   |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | country  | Singapore                                          |
      | city     | Singapore                                          |
      | address1 | 8A MARINA BOULEVARD                                |
      | address2 | MARINA BAY LINK MALL                               |
      | postcode | 018984                                             |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | country  | Singapore                                                  |
      | city     | Singapore                                                  |
      | address1 | 8A MARINA BOULEVARD                                        |
      | address2 | MARINA BAY LINK MALL                                       |
      | postcode | 018984                                                     |
      #    TODO uncomment when issue with mismatch waypoint lat/long is fixed on AV service
#    see comment in https://jira.ninjavan.co/browse/NV-11680
#      | routingZoneId | 30532                                                      |
#      | latitude      | 1.28046794326566                                           |
#      | longitude     | 103.853470148164                                           |
    And DB Core - operator verify orders.data.previousPickupDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}           |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}  |
      | comments | OrderHelper::saveWaypoint                    |
      | seq_no   | 1                                            |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_OLD_TRANSACTION"
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_PP_NEW_TRANSACTION"
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_PP_NEW_TRANSACTION.id}                |
      | txnType         | PICKUP                                     |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_PP_NEW_TRANSACTION.startTime}         |
      | endTimeCustom   | {KEY_PP_NEW_TRANSACTION.endTime}           |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[3].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[3].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[3].endTime}   |


  @ArchiveRouteCommonV2 @HighPriority @update-status
  Scenario: Operator Reschedule Fail Delivery
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
      | globalShipperId | {shipper-v4-id}                                                                                     |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
#    And Operator verify order events on Edit Order V2 page using data below:
#      | tags          | name          | description                                                                                                                                                                                                                    |
#      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Pending New Delivery Status: Fail Old Granular Status: On Vehicle for Delivery New Granular Status: Pending Reschedule Old Order Status: Transit New Order Status: Delivery fail Reason: BATCH_POD_UPDATE |
#    And DB Routing Search - verify transactions record:
#      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}        |
#      | txnType         | DELIVERY                                                  |
#      | txnStatus       | FAIL                                                      |
#      | dnrId           | 2                                                         |
#      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                |
#      | granularStatus  | Pending Reschedule                                        |
#      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].startTime} |
#      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].endTime}   |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Delivery on Edit Order V2 page:
      | recipientName    | test recipient name            |
      | recipientContact | +9727894434                    |
      | recipientEmail   | test@mail.com                  |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                     |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name       |
      | RESCHEDULE |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | SUCCESS |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                    |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail New Delivery Status: Pending Old Granular Status: Pending Reschedule New Granular Status: En-route to Sorting Hub Old Order Status: Delivery fail New Order Status: Transit Reason: RESCHEDULE_ORDER |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |
      | rts        | 0                                          |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | toCountry  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | toName     | test recipient name                        |
      | toEmail    | test@mail.com                              |
      | toContact  | +9727894434                                |
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
      | name     | test recipient name                                |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}         |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}         |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}         |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}          |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrderHelper::saveWaypoint                  |
      | seq_no   | 1                                          |
    When DB Route - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_NEW_TRANSACTION"
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_DD_NEW_TRANSACTION.id}                |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | En-route to Sorting Hub                    |
      | startTimeCustom | {KEY_DD_NEW_TRANSACTION.startTime}         |
      | endTimeCustom   | {KEY_DD_NEW_TRANSACTION.endTime}           |


  @ArchiveRouteCommonV2 @HighPriority @update-status
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Hub Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
      | globalShipperId | {shipper-v4-id} |
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Delivery on Edit Order V2 page:
      | recipientName    | test recipient name             |
      | recipientContact | +9727894434                     |
      | recipientEmail   | test@mail.com                   |
      | deliveryDate     | {date: 0 days next, yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                      |
      | country          | Singapore                       |
      | city             | Singapore                       |
      | address1         | 116 Keng Lee Rd                 |
      | address2         | 15                              |
      | postalCode       | 308402                          |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator refresh page
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                |
      | RESCHEDULE          |
      | UPDATE ADDRESS      |
      | DRIVER INBOUND SCAN |
      | UPDATE AV           |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                                                                                                   |
      | MANUAL ACTION | UPDATE STATUS | Old Delivery Status: Fail New Delivery Status: Pending Old Granular Status: Pending Reschedule New Granular Status: Arrived at Sorting Hub Old Order Status: Delivery fail New Order Status: Transit Reason: RESCHEDULE_ORDER |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status    | PENDING                         |
      | startDate | {date: 0 days next, yyyy-MM-dd} |
      | endDate   | {date: 0 days next, yyyy-MM-dd} |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts        | 0                                  |
      | toAddress1 | 116 Keng Lee Rd                    |
      | toAddress2 | 15                                 |
      | toPostcode | 308402                             |
      | toCountry  | Singapore                          |
      | toCity     | Singapore                          |
      | toName     | test recipient name                |
      | toEmail    | test@mail.com                      |
      | toContact  | +9727894434                        |
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
      | name     | test recipient name                                |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | 116 Keng Lee Rd                                    |
      | address2 | 15                                                 |
      | postcode | 308402                                             |
      | country  | Singapore                                          |
      | city     | Singapore                                          |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | country  | Singapore                                                  |
      | city     | Singapore                                                  |

    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrderHelper::saveWaypoint                  |
      | seq_no   | 1                                          |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_DD_NEW_TRANSACTION"
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_DD_NEW_TRANSACTION.id}                |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Arrived at Sorting Hub                     |
      | startTimeCustom | {KEY_DD_NEW_TRANSACTION.startTime}         |
      | endTimeCustom   | {KEY_DD_NEW_TRANSACTION.endTime}           |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Reschedule Fail Delivery - Latest Scan = Driver Inbound Scan
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
      | globalShipperId | {shipper-v4-id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Delivery on Edit Order V2 page:
      | recipientName    | test recipient name             |
      | recipientContact | +9727894434                     |
      | recipientEmail   | test@mail.com                   |
      | deliveryDate     | {date: 0 days next, yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                      |
      | country          | Singapore                       |
      | city             | Singapore                       |
      | address1         | 116 Keng Lee Rd                 |
      | address2         | 15                              |
      | postalCode       | 308402                          |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                |
      | RESCHEDULE          |
      | UPDATE ADDRESS      |
      | DRIVER INBOUND SCAN |
      | UPDATE AV           |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status    | PENDING                         |
      | startDate | {date: 0 days next, yyyy-MM-dd} |
      | endDate   | {date: 0 days next, yyyy-MM-dd} |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts        | 0                                  |
      | toAddress1 | 116 Keng Lee Rd                    |
      | toAddress2 | 15                                 |
      | toPostcode | 308402                             |
      | toCountry  | Singapore                          |
      | toCity     | Singapore                          |
      | toName     | test recipient name                |
      | toEmail    | test@mail.com                      |
      | toContact  | +9727894434                        |
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
      | name     | test recipient name                                |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | 116 Keng Lee Rd                                    |
      | address2 | 15                                                 |
      | postcode | 308402                                             |
      | country  | Singapore                                          |
      | city     | Singapore                                          |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                |
      | granularStatus  | En-route to Sorting Hub                                   |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].endTime}   |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | country  | Singapore                                                  |
      | city     | Singapore                                                  |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrderHelper::saveWaypoint                  |
      | seq_no   | 1                                          |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Reschedule Fail Pickup - Edit Pickup Address
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest      | { "service_type":"Return","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":true, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                         |
      | addParcelToRouteRequest | {"tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id},"type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver read routes:
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | PICK_UP                                                                                              |
      | failureReasonId | 139                                                                                                  |
      | globalShipperId | {shipper-v4-id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pickup fail |
      | granularStatus | Pickup fail |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Pickup on Edit Order V2 page:
      | senderName    | test sender name               |
      | senderContact | +9727894434                    |
      | senderEmail   | test@mail.com                  |
      | pickupDate    | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot      | 9AM - 12PM                     |
      | country       | Singapore                      |
      | city          | Singapore                      |
      | address1      | 116 Keng Lee Rd                |
      | address2      | 15                             |
      | postalCode    | 308402                         |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator verify order events on Edit Order V2 page using data below:
      | name           |
      | RESCHEDULE     |
      | UPDATE ADDRESS |
      | UPDATE AV      |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And API Core - Operator get order details for previous order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts          | 0                                  |
      | fromAddress1 | 116 Keng Lee Rd                    |
      | fromAddress2 | 15                                 |
      | fromPostcode | 308402                             |
      | fromCountry  | Singapore                          |
      | fromCity     | Singapore                          |
      | fromName     | test sender name                   |
      | fromEmail    | test@mail.com                      |
      | fromContact  | +9727894434                        |
    And DB Core - verify number of transactions is correct after new transactions created
      | order_id               | {KEY_LIST_OF_CREATED_ORDERS[1].id}  |
      | number_of_transactions | 3                                   |
      | number_of_pickup_txn   | 2                                   |
      | pickup_address         | 116 Keng Lee Rd 15 308402 Singapore |
      | number_of_delivery_txn | 1                                   |
    And DB Core - verify transactions record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id} |
      | status   | Pending                                            |
      | routeId  | null                                               |
      | name     | test sender name                                   |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | 116 Keng Lee Rd                                    |
      | address2 | 15                                                 |
      | postcode | 308402                                             |
      | country  | Singapore                                          |
      | city     | Singapore                                          |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].id}        |
      | txnType         | PICKUP                                                    |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                |
      | granularStatus  | Pending Pickup                                            |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].endTime}   |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | country  | Singapore                                                  |
      | city     | Singapore                                                  |
    And DB Core - operator verify orders.data.previousPickupDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}           |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].fromAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].fromPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].fromCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].fromName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].fromEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].fromContact}  |
      | comments | OrderHelper::saveWaypoint                    |
      | seq_no   | 1                                            |

  @ArchiveRouteCommonV2 @HighPriority
  Scenario: Operator Reschedule Fail Delivery - Edit Delivery Address
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":18}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 18                                                                                                  |
      | globalShipperId | {shipper-v4-id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Delivery on Edit Order V2 page:
      | recipientName    | test recipient name            |
      | recipientContact | +9727894434                    |
      | recipientEmail   | test@mail.com                  |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                     |
      | country          | Singapore                      |
      | city             | Singapore                      |
      | address1         | 116 Keng Lee Rd                |
      | address2         | 15                             |
      | postalCode       | 308402                         |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator refresh page
    Then Operator verify order events on Edit Order V2 page using data below:
      | name                |
      | RESCHEDULE          |
      | UPDATE ADDRESS      |
      | DRIVER INBOUND SCAN |
      | UPDATE AV           |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
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
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts        | 0                                  |
      | toAddress1 | 116 Keng Lee Rd                    |
      | toAddress2 | 15                                 |
      | toPostcode | 308402                             |
      | toCountry  | Singapore                          |
      | toCity     | Singapore                          |
      | toName     | test recipient name                |
      | toEmail    | test@mail.com                      |
      | toContact  | +9727894434                        |
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
      | name     | test recipient name                                |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | 116 Keng Lee Rd                                    |
      | address2 | 15                                                 |
      | postcode | 308402                                             |
      | country  | Singapore                                          |
      | city     | Singapore                                          |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                |
      | granularStatus  | En-route to Sorting Hub                                   |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].endTime}   |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | country  | Singapore                                                  |
      | city     | Singapore                                                  |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrderHelper::saveWaypoint                  |
      | seq_no   | 1                                          |
    When DB Route - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |

  @ArchiveRouteCommonV2 @MediumPriority
  Scenario: Operator Reschedule Fail Delivery - Failure Reason Code Id 13
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | generateTo          | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Parcel","service_level":"Standard","from":{"name": "QA core opv2 automation","phone_number": "+65189681","email": "qa@test.co", "address": {"address1": "80 MANDAI LAKE ROAD","address2": "Singapore Zoological","country": "SG","postcode": "238900","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{gradle-next-1-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
      | driverId            | {ninja-driver-id}                                          |
      | expectedRouteId     | {KEY_LIST_OF_CREATED_ROUTES[1].id}                         |
      | expectedWaypointIds | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                  |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                          |
      | routes          | KEY_DRIVER_ROUTES                                                                                   |
      | jobType         | TRANSACTION                                                                                         |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":10}] |
      | jobAction       | FAIL                                                                                                |
      | jobMode         | DELIVERY                                                                                            |
      | failureReasonId | 10                                                                                                  |
      | globalShipperId | {shipper-v4-id} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Delivery fail      |
      | granularStatus | Pending Reschedule |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | FAIL |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status  | FAIL                               |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator click Order Settings -> Reschedule Order on Edit Order V2 page
    And Operator reschedule Delivery on Edit Order V2 page:
      | recipientName    | test recipient name            |
      | recipientContact | +9727894434                    |
      | recipientEmail   | test@mail.com                  |
      | deliveryDate     | {gradle-next-1-day-yyyy-MM-dd} |
      | deliveryTimeslot | 9AM - 12PM                     |
    Then Operator verifies that success react notification displayed:
      | top | Order rescheduled successfully |
    Then Operator refresh page
    Then Operator verify order events on Edit Order V2 page using data below:
      | name       |
      | RESCHEDULE |
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                 |
      | granularStatus | En-route to Sorting Hub |
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
      | id         | {KEY_LIST_OF_CREATED_ORDERS[2].id}         |
      | rts        | 0                                          |
      | toAddress1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | toAddress2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | toPostcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | toCountry  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | toName     | test recipient name                        |
      | toEmail    | test@mail.com                              |
      | toContact  | +9727894434                                |
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
      | name     | test recipient name                                |
      | email    | test@mail.com                                      |
      | contact  | +9727894434                                        |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}         |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}         |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}         |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}          |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].id}        |
      | txnType         | DELIVERY                                                  |
      | txnStatus       | PENDING                                                   |
      | dnrId           | 0                                                         |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId}                |
      | granularStatus  | En-route to Sorting Hub                                   |
      | startTimeCustom | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].startTime} |
      | endTimeCustom   | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].endTime}   |
    Then DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1}                 |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2}                 |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode}                 |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}                  |
    And DB Core - operator verify orders.data.previousDeliveryDetails is updated correctly:
      | orderId  | {KEY_LIST_OF_CREATED_ORDERS[1].id}         |
      | address1 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress1} |
      | address2 | {KEY_LIST_OF_CREATED_ORDERS[1].toAddress2} |
      | postcode | {KEY_LIST_OF_CREATED_ORDERS[1].toPostcode} |
      | country  | {KEY_LIST_OF_CREATED_ORDERS[1].toCountry}  |
      | name     | {KEY_LIST_OF_CREATED_ORDERS[1].toName}     |
      | email    | {KEY_LIST_OF_CREATED_ORDERS[1].toEmail}    |
      | contact  | {KEY_LIST_OF_CREATED_ORDERS[1].toContact}  |
      | comments | OrderHelper::saveWaypoint                  |
      | seq_no   | 1                                          |
    When DB Route - operator get waypoints details for "{KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    Then Operator verifies order details on Edit Order V2 page:
      | zone | {KEY_SORT_RTS_ZONE_TYPE.shortName} |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[3].waypointId} |
      | routingZoneId | {KEY_SORT_RTS_ZONE_TYPE.legacyZoneId}                      |
