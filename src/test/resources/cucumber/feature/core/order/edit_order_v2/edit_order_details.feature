@OperatorV2 @Core @EditOrderV2 @EditOrderDetails
Feature: Edit Order Details

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Change Delivery Verification Method from Edit Order - <delivery_verification_mode> to <new_delivery_verification_mode>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"<delivery_verification_mode>","is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator set Delivery Verification Required to "<new_delivery_verification_mode>" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Delivery verification required updated successfully |
      | waitUntilInvisible | true                                                |
    Then Operator verifies order details on Edit Order V2 page:
      | deliveryVerificationType | <new_delivery_verification_mode> |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE DELIVERY VERIFICATION |
    And DB Core - verify orders record:
      | id                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                      |
      | shipperRefMetadata | ^.*"delivery_verification_mode":"<new_delivery_verification_mode_db>".* |
    And DB Core - verify order_delivery_verifications record:
      | orderId                  | {KEY_LIST_OF_CREATED_ORDERS[1].id}  |
      | deliveryVerificationMode | <new_delivery_verification_mode_db> |
    Examples:
      | delivery_verification_mode | new_delivery_verification_mode | new_delivery_verification_mode_db |
      | OTP                        | None                           | NONE                              |
      | NONE                       | OTP                            | OTP                               |

  Scenario: Operator Edit Priority Level
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator change Priority Level to "2" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top | Current order updated successfully |
    Then Operator verify Delivery Priority Level is "2" on Edit Order V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 2                    |
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id            | {KEY_TRANSACTION.id} |
      | priorityLevel | 0                    |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 17                                 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE SLA |

  Scenario: Operator Edit Order Details on Edit Order V2 page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | deliveryTypes | DELIVERY_SAME_DAY |
      | insuredValue  | 100               |
    Then Operator verifies that success react notification displayed:
      | top                | Current order updated successfully |
      | waitUntilInvisible | true                               |
    Then Operator verifies order details on Edit Order V2 page:
      | deliveryType | DELIVERY_SAME_DAY |
      | insuredValue | 100               |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE INSURANCE                    |
      | description | Insured value changed from 0 to 100 |

  Scenario: Operator Edit Order Details - Edit Parcel Weight
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"weight": 5},"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | weight | 10 |
    Then Operator verifies that success react notification displayed:
      | top                | Current order updated successfully |
      | waitUntilInvisible | true                               |
    Then Operator verifies order details on Edit Order V2 page:
      | weight | 10 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                                |
      | description | Weight changed from 5 to 10 Pricing Weight changed from 5 to 10 |

  Scenario Outline: Operator Edit Order Details - Edit Parcel Size - <oldSize> to <newSize>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                              |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "<oldSize>", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | size | <newSize> |
    Then Operator verifies that success react notification displayed:
      | top                | Current order updated successfully |
      | waitUntilInvisible | true                               |
    Then Operator verifies order details on Edit Order V2 page:
      | size | <newSizeFull> |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                       |
      | description | Parcel Size ID changed from <oldSizeId> to <newSizeId> |
    Examples:
      | oldSize | oldSizeId | newSize | newSizeFull | newSizeId |
      | S       | 0         | M       | MEDIUM      | 1         |
      | M       | 1         | L       | LARGE       | 2         |
      | L       | 2         | XL      | EXTRALARGE  | 3         |
      | XL      | 3         | XXL     | XXLARGE     | 4         |
      | XXL     | 4         | XL      | EXTRALARGE  | 3         |

  Scenario: Operator Edit Order Details - Edit Parcel Dimensions
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                     |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"dimensions":{"length":1,"width":2,"height":3},"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Order Settings -> Edit Order Details on Edit Order V2 page
    When Operator Edit Order Details on Edit Order V2 page:
      | length  | 10 |
      | width   | 20 |
      | breadth | 30 |
    Then Operator verifies that success react notification displayed:
      | top                | Current order updated successfully |
      | waitUntilInvisible | true                               |
    Then Operator verifies order details on Edit Order V2 page:
      | length | 10 |
      | width  | 20 |
      | height | 30 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE DIMENSION                                                                   |
      | description | Length changed from 1 to 10 Width changed from 2 to 20 Height changed from 3 to 30 |

  Scenario: Operator Edit Delivery Details on Edit Order page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}                         |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
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
      | top                | Delivery details updated |
      | waitUntilInvisible | true                     |
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
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                                                                                                                           |
      | description | To Address 1 changed from 9 TUA KONG GREEN to 116 Keng Lee Rd To Address 2 updated: assigned new value 15 To Postcode changed from 455384 to 308402 To City updated: assigned new value Singapore To Country changed from SG to Singapore To Latitude changed from 1.3184395712682 to 1.31401544758955 To Longitude changed from 103.925311276846 to 103.844767199536 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                        |
      | description | To Name changed from Elsa Sender to test sender name To Email changed from elsaf@ninja.com to test@mail.com To Contact changed from +6583014912 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                                                                       |
      | description | ^.*Delivery End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                              |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 116 Keng Lee Rd 15\|\|Singapore\|\|308402 Zone ID: 1399 Destination Hub ID: 1 Lat, Long: 1.31401544758955, 103.844767199536 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
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
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION.waypointId}      |
      | seqNo         | null                              |
      | routeId       | null                              |
      | status        | Pending                           |
      | address1      | 116 Keng Lee Rd                   |
      | address2      | 15                                |
      | postcode      | 308402                            |
      | country       | Singapore                         |
      | routingZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |

  Scenario: Operator Edit Pickup Details on Edit Order page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
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
      | top                | Pickup details updated |
      | waitUntilInvisible | true                   |
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
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                                                                                                                                                              |
      | description | From Address 1 changed from 233E ST. JOHN'S ROAD to 116 Keng Lee Rd From Address 2 updated: assigned new value 15 From Postcode changed from 757995 to 308402 From City updated: assigned new value Singapore From Country changed from SG to Singapore From Latitude changed from 1.45694483734937 to 1.31401544758955 From Longitude changed from 103.825580873988 to 103.844767199536 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                               |
      | description | From Name changed from Elsa Customer to test sender name From Email changed from elsa@ninja.com to test@mail.com From Contact changed from +6583014911 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                                                                     |
      | description | ^.*Pickup End Time changed from .* 15:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                              |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 116 Keng Lee Rd 15\|\|Singapore\|\|308402 Zone ID: 1399 Destination Hub ID: 1 Lat, Long: 1.31401544758955, 103.844767199536 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
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
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION.waypointId}      |
      | seqNo         | null                              |
      | routeId       | null                              |
      | status        | Pending                           |
      | address1      | 116 Keng Lee Rd                   |
      | address2      | 15                                |
      | postcode      | 308402                            |
      | country       | Singapore                         |
      | routingZoneId | {KEY_SORT_ZONE_INFO.legacyZoneId} |

  Scenario: Operator Edit Pickup Details on Edit Order page - Create New Pickup Waypoint
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | {"service_type":"Return","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.31800143464103,"longitude":103.923977928076}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":false,"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
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
      | top                | Pickup details updated |
      | waitUntilInvisible | true                   |
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
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                                             |
      | description | From Address 1 changed from 233E ST. JOHN'S ROAD to 116 Keng Lee Rd From Address 2 updated: assigned new value 15 From Postcode changed from 757995 to 308402 From City updated: assigned new value Singapore From Country changed from SG to Singapore Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                                                                               |
      | description | From Name changed from Elsa Customer to test sender name From Email changed from elsa@ninja.com to test@mail.com From Contact changed from +6583014911 to +9727894434 Is RTS changed from false to false |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE SLA                                                                                                                                                                                 |
      | description | ^Pickup Start Time changed from .* 09:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 09:00:00 Pickup End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit Order V2 page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                             |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 9 TUA KONG GREEN \|\|\|\|455384 Zone ID: 22861 Destination Hub ID: 387 Lat, Long: 1.3184395712682, 103.925311276846 Address Status: VERIFIED AV Mode (Manual/Auto): MANUAL Source: FROM_SHIPPER |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - save the last Pickup transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    When DB Core - operator get waypoints details for "{KEY_TRANSACTION.waypointId}"
    And API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {KEY_CORE_WAYPOINT_DETAILS.latitude}, "longitude":{KEY_CORE_WAYPOINT_DETAILS.longitude}} |
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
    And DB Core - verify waypoints record:
      | id            | {KEY_TRANSACTION.waypointId} |
      | seqNo         | null                         |
      | routeId       | null                         |
      | status        | Pending                      |
      | address1      | 116 Keng Lee Rd              |
      | address2      | 15                           |
      | postcode      | 308402                       |
      | country       | Singapore                    |
      | routingZoneId | -1                           |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op