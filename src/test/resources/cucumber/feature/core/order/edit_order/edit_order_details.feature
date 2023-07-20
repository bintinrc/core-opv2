@OperatorV2 @Core @EditOrder @EditOrderDetails @EditOrder3
Feature: Edit Order Details

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario Outline: Operator Change Delivery Verification Method from Edit Order - <Note> (<hiptest-uid>)
    And API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"<delivery_verification_mode>","is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator set Delivery Verification Required to "<new_delivery_verification_mode>" on on Edit order page
    Then Operator verify Delivery Verification Required is "<new_delivery_verification_mode>" on on Edit order page
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE DELIVERY VERIFICATION |
    When DB Operator get shipper ref metadata of created order
    Then DB Operator make sure shipper ref metadata contains values:
      | deliveryVerificationMode | <new_delivery_verification_mode> |
    When DB Operator get order delivery verifications of created order
    Then DB Operator make sure order delivery verifications contains values:
      | deliveryVerificationMode | <new_delivery_verification_mode> |

    Examples:
      | Note        | delivery_verification_mode | new_delivery_verification_mode | hiptest-uid                              |
      | OTP to NONE | OTP                        | None                           | uid:faa86019-64a6-4755-aa51-252d4fe2dc38 |
      | NONE to OTP | NONE                       | OTP                            | uid:f4cda665-1173-49a8-83ec-e261e69ae554 |

  @happy-path
  Scenario: Operator Edit Pickup Details on Edit Order page
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest | { "service_type":"Return","service_level":"Standard","to":{"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co", "address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Edit Pickup Details on Edit Order page
    And Operator update Pickup Details on Edit Order Page
      | senderName     | test sender name                       |
      | senderContact  | +9727894434                            |
      | senderEmail    | test@mail.com                          |
      | internalNotes  | test internalNotes                     |
      | pickupDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | pickupTimeslot | 9AM - 12PM                             |
      | country        | Singapore                              |
      | city           | Singapore                              |
      | address1       | 116 Keng Lee Rd                        |
      | address2       | 15                                     |
      | postalCode     | 308402                                 |
    Then Operator verifies that success toast displayed:
      | top | Pickup Details Updated |
    And Operator refresh page
    And Operator verify Pickup details on Edit order page using data below:
      | name    | test sender name                         |
      | contact | +9727894434                              |
      | email   | test@mail.com                            |
      | address | {KEY_CREATED_ORDER.buildFullFromAddress} |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                                                                                       |
      | description | ^From Address 1.*116 Keng Lee Rd.*From Address 2.*15.*From Postcode changed.*308402.*From City updated.*Singapore.*From Country.*Singapore.*From Latitude changed.*to 1.31401544758955.*From Longitude changed.*103.844767199536.*Is Rts changed from false to false |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                                               |
      | description | ^From Name changed.*to test sender name.*From Email changed.*to test@mail\.com.*From Contact changed.*\+9727894434.*.*Is Rts changed from false to false |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE SLA                                                                                                                                                                        |
      | description | ^Pickup Start Time changed from .* to {gradle-next-2-working-day-yyyy-MM-dd} 09:00:00 Pickup End Time changed from .* 15:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE AV |
    And DB Operator verify zones record:
      | legacyZoneId | 55       |
      | systemId     | sg       |
      | type         | STANDARD |
    And DB Operator verifies orders record using data below:
      | fromAddress1 | 116 Keng Lee Rd |
      | fromAddress2 | 15              |
      | fromPostcode | 308402          |
      | fromCity     | Singapore       |
      | fromCountry  | Singapore       |
    And Operator save the last Pickup transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | type       | PP                                 |
      | city       | Singapore                          |
      | address1   | 116 Keng Lee Rd                    |
      | address2   | 15                                 |
      | postcode   | 308402                             |
      | country    | Singapore                          |
    And DB Operator verifies waypoints record:
      | id            | {KEY_TRANSACTION_AFTER.waypointId} |
      | address1      | 116 Keng Lee Rd                    |
      | address2      | 15                                 |
      | postcode      | 308402                             |
      | country       | Singapore                          |
      | latitude      | 1.31401544758955                   |
      | longitude     | 103.844767199536                   |
      | routingZoneId | 1399                               |

  @happy-path
  Scenario: Operator Edit Delivery Details on Edit Order page
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                    |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And Operator update Delivery Details on Edit Order Page
      | recipientName    | test sender name                       |
      | recipientContact | +9727894434                            |
      | recipientEmail   | test@mail.com                          |
      | internalNotes    | test internalNotes                     |
      | deliveryDate     | {gradle-next-2-working-day-yyyy-MM-dd} |
      | deliveryTimeslot | 9AM - 12PM                             |
      | country          | Singapore                              |
      | city             | Singapore                              |
      | address1         | 116 Keng Lee Rd                        |
      | address2         | 15                                     |
      | postalCode       | 308402                                 |
    Then Operator verifies that success toast displayed:
      | top | Delivery Details Updated |
    And Operator refresh page
    And Operator verify Delivery details on Edit order page using data below:
      | name    | test sender name                              |
      | contact | +9727894434                                   |
      | email   | test@mail.com                                 |
      | address | 116 Keng Lee Rd 15 308402 Singapore Singapore |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE ADDRESS                                                                                                                                                                                |
      | description | ^To Address 1.*116 Keng Lee Rd.*To Address 2.*15.*To Postcode changed.*308402.*To City updated.*Singapore.*To Country.*Singapore.*To Latitude changed.*To Longitude changed.*Is Rts changed.* |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE CONTACT INFORMATION                                                                                                       |
      | description | ^To Name changed.*to test sender name.*To Email changed.*to test@mail\.com.*To Contact changed.*\+9727894434.*.*Is Rts changed.* |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE SLA                                                                                       |
      | description | ^.*Delivery End Time changed from .* 22:00:00 to {gradle-next-2-working-day-yyyy-MM-dd} 12:00:00 |
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE AV                                                                                                                                                                                                                                              |
      | description | User: AUTO (system AV) (support@ninjavan.co) Address: 116 Keng Lee Rd 15\|\|Singapore\|\|308402 Zone ID: 1399 Destination Hub ID: 1 Lat, Long: 1.31401544758955, 103.844767199536 Address Status: VERIFIED AV Mode (Manual/Auto): AUTO Source: AUTO_AV |
    And DB Addressing - verify zones record:
      | legacyZoneId | 1399     |
      | systemId     | sg       |
      | type         | STANDARD |
    And DB Core - verify orders record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | toAddress1 | 116 Keng Lee Rd                    |
      | toAddress2 | 15                                 |
      | toPostcode | 308402                             |
      | toCity     | Singapore                          |
      | toCountry  | Singapore                          |
    Then DB Core - verify transactions record:
      | id         | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id}         |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | status     | Pending                                                    |
      | routeId    | null                                                       |
      | address1   | 116 Keng Lee Rd                                            |
      | address2   | 15                                                         |
      | postcode   | 308402                                                     |
      | country    | Singapore                                                  |
    And DB Core - verify waypoints record:
      | id       | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | seqNo    | null                                                       |
      | routeId  | null                                                       |
      | status   | Pending                                                    |
      | address1 | 116 Keng Lee Rd                                            |
      | address2 | 15                                                         |
      | postcode | 308402                                                     |
      | country  | Singapore                                                  |

  Scenario: Operator Edit Instructions of an Order on Edit Order Page (uid:a5de8db3-f5a2-4bda-8984-96794753d26c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator click Order Settings -> Edit Instructions on Edit Order page
    When Operator enter Order Instructions on Edit Order page:
      | pickupInstruction   | new pickup instruction   |
      | deliveryInstruction | new delivery instruction |
    When Operator verify Order Instructions are updated on Edit Order Page
    And DB Operator verify order_events record for the created order:
      | type | 14 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE INSTRUCTION |

  @happy-path
  Scenario: Operator Edit Priority Level (uid:849b151c-967b-4a20-afba-73fc9334570d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator change Priority Level to "2" on Edit Order page
    Then Operator verify Delivery Priority Level is "2" on Edit Order page
    And DB Operator verify next Delivery transaction values are updated for the created order:
      | priorityLevel | 2 |
    And DB Operator verify next Pickup transaction values are updated for the created order:
      | priorityLevel | 0 |
    And DB Operator verify order_events record for the created order:
      | type | 17 |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE SLA |

  @happy-path
  Scenario: Operator Edit Order Details on Edit Order page (uid:1884a911-4599-4faa-8d63-a9b984f1c989)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page
    And Operator waits for 5 seconds
    Then Operator Edit Order Details on Edit Order page successfully

  Scenario: Operator Edit Pickup Details on Edit Order page - Create New Pickup Waypoint
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator click Pickup -> Edit Pickup Details on Edit Order page
    And API Operator get order details
    And Operator update Pickup Details on Edit Order Page
      | senderName               | test sender name          |
      | senderContact            | +9727894434               |
      | senderEmail              | test@mail.com             |
      | internalNotes            | test internalNotes        |
      | pickupDate               | {{next-1-day-yyyy-MM-dd}} |
      | pickupTimeslot           | 9AM - 12PM                |
      | country                  | Singapore                 |
      | city                     | Singapore                 |
      | address1                 | 116 Keng Lee Rd           |
      | address2                 | 15                        |
      | postalCode               | 308402                    |
      | shipperRequestedToChange | true                      |
      | assignPickupLocation     | true                      |
    Then Operator verifies that success toast displayed:
      | top                | Pickup Details Updated |
      | waitUntilInvisible | true                   |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE SLA |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE AV |
    And DB Operator verify Pickup transaction record of order "KEY_CREATED_ORDER_ID":
      | address1 | 116 Keng Lee Rd  |
      | address2 | 15               |
      | postcode | 308402           |
      | city     | Singapore        |
      | country  | Singapore        |
      | name     | test sender name |
      | email    | test@mail.com    |
      | contact  | +9727894434      |

  Scenario: Operator Edit Order Details - Edit Parcel Weight
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order details on Edit Order page:
      | weight | 5 |
    And Operator waits for 10 seconds
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 5 |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE DIMENSION                                               |
      | description | Weight changed from 1 to 5\nPricing Weight changed from 1 to 5 |

  Scenario Outline: Operator Edit Order Details - Edit Parcel Size - <oldSize> to <newSize>
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "<oldSize>", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order details on Edit Order page:
      | size | <newSize> |
    And Operator waits for 10 seconds
    Then Operator verifies dimensions information on Edit Order page:
      | size | <newSizeFull> |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE DIMENSION                                       |
      | description | Parcel Size Id changed from <oldSizeId> to <newSizeId> |
    Examples:
      | oldSize | oldSizeId | newSize | newSizeFull | newSizeId |
      | S       | 0         | M       | MEDIUM      | 1         |
      | M       | 1         | L       | LARGE       | 2         |
      | L       | 2         | XL      | EXTRALARGE  | 3         |
      | XL      | 3         | XXL     | XXLARGE     | 4         |
      | XXL     | 4         | XL      | EXTRALARGE  | 3         |

  Scenario: Operator Edit Order Details - Edit Parcel Dimensions
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator update order details on Edit Order page:
      | length  | 5 |
      | width   | 6 |
      | breadth | 7 |
    And Operator waits for 10 seconds
    Then Operator verifies dimensions information on Edit Order page:
      | length | 5 |
      | width  | 6 |
      | height | 7 |
    And Operator verifies Latest Event is "UPDATE DIMENSION" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name        | UPDATE DIMENSION                                                                                                |
      | description | Length updated: assigned new value 5\nWidth updated: assigned new value 6\nHeight updated: assigned new value 7 |
