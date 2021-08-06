@OperatorV2 @Core @Order @EditOrder @happy-path
Feature: Edit Order

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Change Delivery Verification Method from Edit Order - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
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
      | OTP to NONE | OTP                        | None                           | uid:cc3af0ad-d92c-4786-a718-5c9187807dab |
      | NONE to OTP | NONE                       | OTP                            | uid:c7a5a67e-b0f5-4901-8b1f-049bb1a4668a |

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Delivery Details on Edit Order page (uid:2f315ce8-61c0-499b-8430-059ff2e09679)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Edit Delivery Details on Edit Order page
    And Operator update Delivery Details on Edit Order Page
      | recipientName    | test sender name          |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then Operator verify Delivery "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Delivery "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Delivery "UPDATE SLA" order event description on Edit order page
    And Operator verifies Delivery Details are updated on Edit Order Page
    And Operator verifies Delivery Transaction is updated on Edit Order Page
    And DB Operator verifies delivery info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 17 |
      | 11 |
      | 12 |
    And DB Operator verify Delivery '17' order_events record for the created order
    And DB Operator verify Delivery transaction record is updated for the created order
    And DB Operator verify Delivery waypoint record is updated

  @DeleteOrArchiveRoute
  Scenario: Operator Edit Pickup Details on Edit Order page (uid:0954ea50-2ab7-4072-9053-3868759fbe02)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Edit Pickup Details on Edit Order page
    And Operator update Pickup Details on Edit Order Page
      | senderName     | test sender name          |
      | senderContact  | +9727894434               |
      | senderEmail    | test@mail.com             |
      | internalNotes  | test internalNotes        |
      | pickupDate     | {{next-1-day-yyyy-MM-dd}} |
      | pickupTimeslot | 9AM - 12PM                |
      | country        | Singapore                 |
      | city           | Singapore                 |
      | address1       | 116 Keng Lee Rd           |
      | address2       | 15                        |
      | postalCode     | 308402                    |
    Then Operator verify Pickup "UPDATE ADDRESS" order event description on Edit order page
    And Operator verify Pickup "UPDATE CONTACT INFORMATION" order event description on Edit order page
    And Operator verify Pickup "UPDATE SLA" order event description on Edit order page
    And Operator verifies Pickup Details are updated on Edit Order Page
    And Operator verifies Pickup Transaction is updated on Edit Order Page
    And DB Operator verifies pickup info is updated in order record
    And DB Operator verify the order_events record exists for the created order with type:
      | 17 |
      | 11 |
      | 12 |
    And DB Operator verify Pickup '17' order_events record for the created order
    And DB Operator verify Pickup transaction record is updated for the created order
    And DB Operator verify Pickup waypoint record is updated

  Scenario: Operator Tag Order to DP (uid:9de17044-af55-4ae0-9a61-a0cf85f82403)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    Then Operator verifies delivery is indicated by 'Ninja Collect' icon on Edit Order Page
    When DB Operator get DP address by ID = "{dpms-id}"
    Then DB Operator verifies orders record using data below:
      | toAddress1 | GET_FROM_CREATED_ORDER |
      | toAddress2 | GET_FROM_CREATED_ORDER |
      | toPostcode | GET_FROM_CREATED_ORDER |
      | toCity     | GET_FROM_CREATED_ORDER |
      | toCountry  | GET_FROM_CREATED_ORDER |
      | toState    |                        |
      | toDistrict |                        |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | {dpms-id}              |
      | address1              | GET_FROM_CREATED_ORDER |
      | address2              | GET_FROM_CREATED_ORDER |
      | postcode              | GET_FROM_CREATED_ORDER |
      | city                  | GET_FROM_CREATED_ORDER |
      | country               | GET_FROM_CREATED_ORDER |
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 18 |

  Scenario: Operator Edit Priority Level (uid:497844f8-45e3-44cd-b6ac-5687b1a29594)
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

  Scenario: Operator Edit Order Details on Edit Order page (uid:dda649d5-6ccf-4f12-ac87-4f6e36d3b896)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Order Details on Edit Order page
    When Operator Edit Order Details on Edit Order page
    Then Operator Edit Order Details on Edit Order page successfully

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Add to Route on Delivery Menu Edit Order Page - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order route on Edit Order page using data below:
      | type    | Delivery               |
      | routeId | {KEY_CREATED_ROUTE_ID} |
    Then Operator verify Latest Route ID is "{KEY_CREATED_ROUTE_ID}" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE         |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies route_monitoring_data record

    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:e0323f71-ba8c-435f-afa0-c16747c32e6f | Normal    |
      | Return | uid:f4077b6d-4a69-4e5b-8cf1-e3e647ead9df | Return    |

  @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Parcel from a Route - PICKUP (uid:bb2ffdf8-eb64-4eab-91b4-ea4ac3f10e26)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Operator start the route
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Pickup -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verify Pickup transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Pickup transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Fail Pickup (uid:791d7d9a-0fc3-4c7a-97f5-46ae351b9064)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail pickup waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Pickup on Edit Order Page
      | senderName     | test sender name          |
      | senderContact  | +9727894434               |
      | senderEmail    | test@mail.com             |
      | internalNotes  | test internalNotes        |
      | pickupDate     | {{next-1-day-yyyy-MM-dd}} |
      | pickupTimeslot | 9AM - 12PM                |
      | country        | Singapore                 |
      | city           | Singapore                 |
      | address1       | 116 Keng Lee Rd           |
      | address2       | 15                        |
      | postalCode     | 308402                    |
    Then DB Operator verifies pickup info is updated in order record
    And DB Operator verify Pickup waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Pending        |
      | granularStatus | Pending Pickup |

  @DeleteOrArchiveRoute
  Scenario: Operator Reschedule Fail Delivery (uid:efd3994c-9f5c-45e9-bfe4-f7ae24b4c6ec)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator open Route Manifest page for route ID "{KEY_CREATED_ROUTE_ID}"
    And Operator fail delivery waypoint from Route Manifest page
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Reschedule Order on Edit Order page
    And Operator reschedule Delivery on Edit Order Page
      | recipientName    | test recipient name       |
      | recipientContact | +9727894434               |
      | recipientEmail   | test@mail.com             |
      | internalNotes    | test internalNotes        |
      | deliveryDate     | {{next-1-day-yyyy-MM-dd}} |
      | deliveryTimeslot | 9AM - 12PM                |
      | country          | Singapore                 |
      | city             | Singapore                 |
      | address1         | 116 Keng Lee Rd           |
      | address2         | 15                        |
      | postalCode       | 308402                    |
    Then DB Operator verifies delivery info is updated in order record
    And DB Operator verify Delivery waypoint record for Pending transaction
    And DB Operator verifies orders record using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |

  @DeleteOrArchiveRoute
  Scenario: Operator Cancel RTS from Edit Order Page (uid:16012ebc-23b9-4553-8d1e-275aa8bf8913)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
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
    And API Driver failed the delivery of the created parcel
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator cancel RTS on Edit Order page
    Then Operator verifies RTS tag is hidden in delivery details box on Edit Order page
    And Operator verifies Latest Event is "REVERT RTS" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REVERT RTS |
    And DB Operator verifies orders record using data below:
      | rts | 0 |

  Scenario: Edit Cash Collection Details - Add Cash on Delivery (uid:df80eafe-f150-4b8e-ba62-beb1a43e7398)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to yes
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Edit Cash Collection Details - Update Cash on Delivery (uid:31927712-7e5f-4772-9435-44e4e936dae7)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change the COD value to "100"
    And Operator refresh page
    Then Operator verify COD value is updated to "100"
    And Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Edit Cash Collection Details - Remove Cash on Delivery (uid:126396fb-36d2-430e-879c-4bdc5ef253e6)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"cash_on_delivery":23.57, "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Edit Cash Collection Details on Edit Order page
    And Operator change Cash on Delivery toggle to no
    And Operator refresh page
    Then Operator verify "UPDATE CASH" order event description on Edit order page
    And DB Operator verify the order_events record exists for the created order with type:
      | 15 |

  Scenario: Operator Untag/Remove Order from DP (uid:6f8ecea3-8835-4bea-9337-1cc8a4f5f10c)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":23.57, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator tags order to "{dpms-id}" DP on Edit Order Page
    And Operator click Delivery -> DP Drop Off Setting on Edit Order page
    And Operator untags order from DP on Edit Order Page
    Then Operator verifies delivery is not indicated by 'Ninja Collect' icon on Edit Order Page
#  initially city is ""
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | distribution_point_id | 0                      |
      | address1              | GET_FROM_CREATED_ORDER |
      | address2              | GET_FROM_CREATED_ORDER |
      | postcode              | GET_FROM_CREATED_ORDER |
      | city                  | GET_FROM_CREATED_ORDER |
      | country               | GET_FROM_CREATED_ORDER |
    And DB Operator verifies delivery info is updated in order record
    And Operator verifies Delivery Details are updated on Edit Order Page
    And DB Operator verify Delivery waypoint record is updated
    And DB Operator verify the order_events record exists for the created order with type:
      | 35 |

  @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Parcel from a Route - DELIVERY (uid:ae47574b-3ae9-4c6f-bd73-3c29125492f1)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator start the route
    And API Operator get order details
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Delivery -> Pull from Route on Edit Order page
    And Operator pull out parcel from the route for Delivery on Edit Order page
    Then Operator verify Delivery transaction on Edit order page using data below:
      | routeId |  |
    And Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify order_events record for the created order:
      | type | 33 |
    Then DB Operator verify next Delivery transaction values are updated for the created order:
      | routeId | 0 |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies waypoint for Delivery transaction is deleted from route_waypoint table
    And DB Operator verifies transaction route id is null
    And DB Operator verifies route_waypoint is hard-deleted
    And DB Operator verifies route_monitoring_data is hard-deleted

  Scenario: Cancel Order - Pending Pickup (uid:0af2c2aa-51e1-4780-8b8c-0207feed6dfe)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    When Operator cancel order on Edit order page using data below:
      | cancellationReason | Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator get order details
    Then Operator verify order status is "Cancelled" on Edit Order page
    And Operator verify order granular status is "Cancelled" on Edit Order page
    And Operator verify order summary on Edit order page using data below:
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Pickup transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And API Operator verify Delivery transaction of the created order using data below:
      | status   | CANCELLED                                                                          |
      | comments | Cancellation reason : Cancelled by automated test {gradle-current-date-yyyy-MM-dd} |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | CANCELLED |
    And Operator verify order event on Edit order page using data below:
      | name | CANCEL |
    And DB Operator verify Pickup waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verify Jaro Scores of the created order after cancel

  Scenario: Operator Manually Complete Order on Edit Order Page (uid:2fd50201-9432-497a-9b7d-71c49ab27330)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page
    Then Operator verify the order completed successfully on Edit Order page

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Add to Route on Pickup Menu Edit Order Page - <Note> (<hiptest-uid>)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator add created order to the <routeType> route on Edit Order page
    And Operator refresh page
    Then Operator verify the order is added to the <routeType> route on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE         |
      | routeId | KEY_CREATED_ROUTE_ID |
    And DB Operator verify <routeType> waypoint of the created order using data below:
      | status | ROUTED |
    And DB Operator verifies transaction routed to new route id
    And DB Operator verifies route_waypoint record exist
    And DB Operator verifies waypoint status is "ROUTED"
    And DB Operator verifies route_monitoring_data record

    Examples:
      | Note              | hiptest-uid                              | orderType | routeType |
      | Return - Delivery | uid:75691bdc-712b-4b5a-a19a-8bd10ff8bba7 | Return    | Delivery  |
      | Return - Pickup   | uid:5b768149-fbee-4f18-9970-942e86ce68c8 | Return    | Pickup    |

  Scenario: Operator Delete Order - Status = Pending Pickup (uid:137ca011-9ebb-4f49-b917-e9d2872da9a4)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Delete Order on Edit Order page
    And Operator delete order on Edit Order Page
    Then Operator verifies All Orders Page is displayed
    And DB Operator verifies order is deleted

  Scenario: Operator Resume a Cancelled Order on Edit Order page (uid:e0c63f94-c094-4f25-95db-34c4a0c528d5)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status to = "Cancelled"
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator resume order on Edit Order page
    Then Operator verify order status is "Pending" on Edit Order page
    And Operator verify order granular status is "Pending Pickup" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit order page using data below:
      | status | PENDING |
    And Operator verify order event on Edit order page using data below:
      | name | RESUME |

  Scenario: Operator RTS an Order on Edit Order Page - Arrived at Sorting Hub, Delivery Unrouted (uid:ad15e79d-7fcf-40ff-92cd-bb2667c8379f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    Then Operator verify order event on Edit order page using data below:
      | name | RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
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
    And DB Operator verifies orders record using data below:
      | rts | 1 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op