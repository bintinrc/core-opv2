@OperatorV2 @Core @EditOrderV2 @EditPickupDeliveryDetails
Feature: Edit Order Details

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  TODO Uncomment the verification step when bug ticket NV-11586 is solved
  @happy-path @HighPriority
  Scenario: Operator Edit Delivery Details on Edit Order page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> Edit delivery details on Edit Order V2 page
    When Operator edit delivery details on Edit Order V2 page:
      | recipientName    | test sender name                       |
      | recipientContact | +9727894434                            |
      | recipientEmail   | test@mail.com                          |
      | internalNotes    | test internalNotes                     |
      | deliveryDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                             |
      | country          | Singapore                              |
      | city             | Singapore                              |
      | address1         | 116 Keng Lee Rd                        |
      | address2         | 15                                     |
      | postalCode       | 308402                                 |
    Then Operator verifies that success react notification displayed:
      | top | Delivery details updated |
    And Operator refresh page
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | test sender name                              |
      | contact | +9727894434                                   |
      | email   | test@mail.com                                 |
      | address | 116 Keng Lee Rd 15 308402 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                      |
      | status             | PENDING                                       |
      | name               | test sender name                              |
      | contact            | +9727894434                                   |
      | email              | test@mail.com                                 |
      | destinationAddress | 116 Keng Lee Rd 15 Singapore Singapore 308402 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                                                                                                  |
      | description | ^.*To Address 1 changed from 9 TUA KONG GREEN to 116 Keng Lee Rd To Address 2 updated: assigned new value 15 To Postcode changed from 455384 to 308402 To City updated: assigned new value Singapore To Country changed from SG to Singapore To Latitude changed from 1.3184395712682 to .* To Longitude changed from 103.925311276846 to .* Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                        |
      | description | To Name changed from Elsa Sender to test sender name To Email changed from elsaf@ninja.com to test@mail.com To Contact changed from +6583014912 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE SLA |
#      | description | ^.*Delivery End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 116 Keng Lee Rd                    |
      | toAddress2 | 15                                 |
      | toPostcode | 308402                             |
      | toCity     | Singapore                          |
      | toCountry  | Singapore                          |
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}         |
      | waypointId | {KEY_TRANSACTION.waypointId} |
      | status     | Pending                      |
      | routeId    | null                         |
      | address1   | 116 Keng Lee Rd              |
      | address2   | 15                           |
      | postcode   | 308402                       |
      | country    | Singapore                    |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId}      |
      | seqNo         | null                              |
      | routeId       | null                              |
      | status        | Pending                           |
      | address1      | 116 Keng Lee Rd                   |
      | address2      | 15                                |
      | postcode      | 308402                            |
      | country       | Singapore                         |
      | routingZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |

  @happy-path @HighPriority
  Scenario: Operator Edit Pickup Details on Edit Order page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Pickup -> Edit pickup details on Edit Order V2 page
    When Operator edit pickup details on Edit Order V2 page:
      | senderName    | test sender name                       |
      | senderContact | +9727894434                            |
      | senderEmail   | test@mail.com                          |
      | internalNotes | test internalNotes                     |
      | pickupDate    | {gradle-next-2-working-day-yyyy-MM-dd} |
      | timeslot      | 9AM - 12PM                             |
      | country       | Singapore                              |
      | city          | Singapore                              |
      | address1      | 116 Keng Lee Rd                        |
      | address2      | 15                                     |
      | postalCode    | 308402                                 |
    Then Operator verifies that success react notification displayed:
      | top | Pickup details updated |
    And Operator refresh page
    And Operator unmask Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | name    | test sender name                              |
      | contact | +9727894434                                   |
      | email   | test@mail.com                                 |
      | address | 116 Keng Lee Rd 15 308402 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | PICKUP                                        |
      | status             | PENDING                                       |
      | name               | test sender name                              |
      | contact            | +9727894434                                   |
      | email              | test@mail.com                                 |
      | destinationAddress | 116 Keng Lee Rd 15 Singapore Singapore 308402 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                                                                                                                     |
      | description | ^.*From Address 1 changed from 233E ST. JOHN'S ROAD to 116 Keng Lee Rd From Address 2 updated: assigned new value 15 From Postcode changed from 757995 to 308402 From City updated: assigned new value Singapore From Country changed from SG to Singapore From Latitude changed from 1.45694483734937 to .* From Longitude changed from 103.825580873988 to .* Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                               |
      | description | From Name changed from Elsa Customer to test sender name From Email changed from elsa@ninja.com to test@mail.com From Contact changed from +6583014911 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                                                                     |
      | description | ^.*Pickup End Time changed from .* 15:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | fromAddress1 | 116 Keng Lee Rd                    |
      | fromAddress2 | 15                                 |
      | fromPostcode | 308402                             |
      | fromCity     | Singapore                          |
      | fromCountry  | Singapore                          |
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}         |
      | waypointId | {KEY_TRANSACTION.waypointId} |
      | status     | Pending                      |
      | routeId    | null                         |
      | address1   | 116 Keng Lee Rd              |
      | address2   | 15                           |
      | postcode   | 308402                       |
      | country    | Singapore                    |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | PICKUP                                     |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Pending Pickup                             |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId}      |
      | seqNo         | null                              |
      | routeId       | null                              |
      | status        | Pending                           |
      | address1      | 116 Keng Lee Rd                   |
      | address2      | 15                                |
      | postcode      | 308402                            |
      | country       | Singapore                         |
      | routingZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |

  @HighPriority
  Scenario: Operator Edit Pickup Details on Edit Order page - Create New Pickup Waypoint
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":false,"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Pickup -> Edit pickup details on Edit Order V2 page
    When Operator edit pickup details on Edit Order V2 page:
      | senderName               | test sender name                       |
      | senderContact            | +9727894434                            |
      | senderEmail              | test@mail.com                          |
      | internalNotes            | test internalNotes                     |
      | pickupDate               | {gradle-next-2-working-day-yyyy-MM-dd} |
      | timeslot                 | 9AM - 12PM                             |
      | shipperRequestedToChange | true                                   |
      | assignPickupLocation     | true                                   |
      | country                  | Singapore                              |
      | city                     | Singapore                              |
      | address1                 | 116 Keng Lee Rd                        |
      | address2                 | 15                                     |
      | postalCode               | 308402                                 |
    Then Operator verifies that success react notification displayed:
      | top | Pickup details updated |
    And Operator refresh page
    And Operator unmask Edit Order V2 page
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | name    | test sender name                              |
      | contact | +9727894434                                   |
      | email   | test@mail.com                                 |
      | address | 116 Keng Lee Rd 15 308402 Singapore Singapore |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | PICKUP                                        |
      | status             | PENDING                                       |
      | name               | test sender name                              |
      | contact            | +9727894434                                   |
      | email              | test@mail.com                                 |
      | destinationAddress | 116 Keng Lee Rd 15 Singapore Singapore 308402 |
    And Operator unmask Edit Order V2 page
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                |
      | description | ^.*From Address 1 changed from 233E ST. JOHN'S ROAD to 116 Keng Lee Rd From Address 2 updated: assigned new value 15 From Postcode changed from 757995 to 308402 From City updated: assigned new value Singapore From Country changed from SG to Singapore Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                               |
      | description | From Name changed from Elsa Customer to test sender name From Email changed from elsa@ninja.com to test@mail.com From Contact changed from +6583014911 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                                                                                                                                                                 |
      | description | ^Pickup Start Time changed from .* 09:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 09:00:00 Pickup End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify orders record:
      | id           | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | fromAddress1 | 116 Keng Lee Rd                    |
      | fromAddress2 | 15                                 |
      | fromPostcode | 308402                             |
      | fromCity     | Singapore                          |
      | fromCountry  | Singapore                          |
    Then DB Core - verify transactions record:
      | id              | {KEY_TRANSACTION.id}         |
      | waypointId      | {KEY_TRANSACTION.waypointId} |
      | status          | Pending                      |
      | routeId         | null                         |
      | address1        | 116 Keng Lee Rd              |
      | address2        | 15                           |
      | postcode        | 308402                       |
      | country         | Singapore                    |
      | startTimeCustom | {KEY_TRANSACTION.startTime}  |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}    |
    And DB Routing Search - verify transactions record:
      | txnId              | {KEY_TRANSACTION.id}         |
      | waypointId         | {KEY_TRANSACTION.waypointId} |
      | txnStatus          | PENDING                      |
      | txnType            | PICKUP                       |
      | startTxnTimeCustom | {KEY_TRANSACTION.startTime}  |
      | endTxnTimeCustom   | {KEY_TRANSACTION.endTime}    |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId} |
      | seqNo         | null                         |
      | routeId       | null                         |
      | status        | Pending                      |
      | address1      | 116 Keng Lee Rd              |
      | address2      | 15                           |
      | postcode      | 308402                       |
      | country       | Singapore                    |
      | routingZoneId | null                         |

#  TODO Uncomment the verification step when bug ticket NV-11586 is solved
  @HighPriority
  Scenario: Operator Edit Delivery Details on Edit Order page - AASH order merged with another order
    Given API Order - Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And Operator click Delivery -> Edit delivery details on Edit Order V2 page
    When Operator edit delivery details on Edit Order V2 page:
      | recipientName    | test sender name                       |
      | recipientContact | +9727894434                            |
      | recipientEmail   | test@mail.com                          |
      | internalNotes    | test internalNotes                     |
      | deliveryDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                             |
      | country          | Singapore                              |
      | city             | Singapore                              |
      | address1         | 116 Keng Lee Rd                        |
      | address2         | 15                                     |
      | postalCode       | 308402                                 |
    Then Operator verifies that success react notification displayed:
      | top | Delivery details updated |
    And Operator refresh page
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | test sender name                              |
      | contact | +9727894434                                   |
      | email   | test@mail.com                                 |
      | address | 116 Keng Lee Rd 15 308402 Singapore Singapore |
    And API Core - Operator verifies "Delivery" transactions of following orders have different waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                                      |
      | status             | PENDING                                       |
      | name               | test sender name                              |
      | contact            | +9727894434                                   |
      | email              | test@mail.com                                 |
      | destinationAddress | 116 Keng Lee Rd 15 Singapore Singapore 308402 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                                                                                                  |
      | description | ^.*To Address 1 changed from 9 TUA KONG GREEN to 116 Keng Lee Rd To Address 2 updated: assigned new value 15 To Postcode changed from 455384 to 308402 To City updated: assigned new value Singapore To Country changed from SG to Singapore To Latitude changed from 1.3184395712682 to .* To Longitude changed from 103.925311276846 to .* Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                        |
      | description | To Name changed from Elsa Sender to test sender name To Email changed from elsaf@ninja.com to test@mail.com To Contact changed from +6583014912 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE SLA |
#      | description | ^.*Delivery End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 116 Keng Lee Rd                    |
      | toAddress2 | 15                                 |
      | toPostcode | 308402                             |
      | toCity     | Singapore                          |
      | toCountry  | Singapore                          |
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}         |
      | waypointId | {KEY_TRANSACTION.waypointId} |
      | status     | Pending                      |
      | routeId    | null                         |
      | address1   | 116 Keng Lee Rd              |
      | address2   | 15                           |
      | postcode   | 308402                       |
      | country    | Singapore                    |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId}      |
      | seqNo         | null                              |
      | routeId       | null                              |
      | status        | Pending                           |
      | address1      | 116 Keng Lee Rd                   |
      | address2      | 15                                |
      | postcode      | 308402                            |
      | country       | Singapore                         |
      | routingZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Arrived at Sorting Hub                     |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId} |
      | routeId  | null                         |
      | seqNo    | null                         |
      | status   | Pending                      |

#  TODO Uncomment the verification step when bug ticket NV-11586 is solved
  @HighPriority
  Scenario: Operator Edit Delivery Details on Edit Order page - AASH order merged with another order added to route
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
    And Operator click Delivery -> Edit delivery details on Edit Order V2 page
    When Operator edit delivery details on Edit Order V2 page:
      | recipientContact | +9727894434                            |
      | deliveryDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | timeslot         | 9AM - 12PM                             |
    Then Operator verifies that success react notification displayed:
      | top | Delivery details updated |
    And Operator refresh page
    And Operator unmask Edit Order V2 page
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | name    | test sender name           |
      | contact | +9727894434                |
      | email   | test@mail.com              |
      | address | 9 TUA KONG GREEN 455384 SG |
    Then API Core - Operator verifies "Delivery" transactions of following orders have same waypoint id:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    And Operator verify transaction on Edit Order V2 page using data below:
      | type               | DELIVERY                           |
      | status             | PENDING                            |
      | routeId            | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | name               | test sender name                   |
      | contact            | +9727894434                        |
      | email              | test@mail.com                      |
      | destinationAddress | 9 TUA KONG GREEN SG 455384         |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                            |
      | description | To Contact changed from +6583014912 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE SLA |
#      | description | ^.*Delivery End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Route - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_ROUTE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_ROUTE_WAYPOINT_DETAILS.longitude}} |
    And DB Addressing - verify zones record:
      | legacyZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |
      | systemId     | sg                                |
      | type         | STANDARD                          |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 9 TUA KONG GREEN                   |
      | toPostcode | 455384                             |
      | toCountry  | SG                                 |
    Then DB Core - verify transactions record:
      | id         | {KEY_TRANSACTION.id}               |
      | waypointId | {KEY_TRANSACTION.waypointId}       |
      | status     | Pending                            |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | address1   | 9 TUA KONG GREEN                   |
      | address2   | null                               |
      | postcode   | 455384                             |
      | country    | SG                                 |
    And DB Routing Search - verify transactions record:
      | txnId           | {KEY_TRANSACTION.id}                       |
      | txnType         | DELIVERY                                   |
      | txnStatus       | PENDING                                    |
      | dnrId           | 0                                          |
      | trackingId      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus  | Arrived at Sorting Hub                     |
      | startTimeCustom | {KEY_TRANSACTION.startTime}                |
      | endTimeCustom   | {KEY_TRANSACTION.endTime}                  |
    And DB Route - verify waypoints record:
      | legacyId      | {KEY_TRANSACTION.waypointId}       |
      | seqNo         | 100                                |
      | routeId       | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | status        | Routed                             |
      | address1      | 9 TUA KONG GREEN                   |
      | address2      | null                               |
      | postcode      | 455384                             |
      | country       | SG                                 |
      | routingZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId}  |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION.waypointId}       |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | seqNo    | 100                                |
      | status   | Routed                             |
