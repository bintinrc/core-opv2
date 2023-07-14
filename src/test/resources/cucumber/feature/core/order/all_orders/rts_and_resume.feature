@OperatorV2 @Core @AllOrders @RtsandResume
Feature: All Orders - RTS & Resume

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator RTS Failed Delivery Order on All Orders Page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Driver collect all his routes
    Given API Driver get pickup/delivery waypoint of the created order
    Given API Operator Van Inbound parcel
    Given API Operator start the route
    Given API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 5           |
      | failureReasonIndexMode | FIRST       |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
      | expectedStatus       | DELIVERY_FAIL        |
    When API Operator get order details
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator RTS single order on next day on All Orders page
    Then API Operator verify order info after failed delivery aged parcel global inbounded and RTS-ed on next day
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                |
      | startDate | {gradle-next-1-working-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-working-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name | RTS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit order page using data below:
      | name | UPDATE CONTACT INFORMATION |
    And Operator verifies RTS tag is displayed in delivery details box on Edit Order page
    And API Operator get order details
    And Operator save the last Delivery transaction of the created order as "KEY_TRANSACTION"
    And DB Operator verifies waypoints record:
      | id     | {KEY_TRANSACTION.waypointId} |
      | status | Pending                      |
    And DB Operator verifies orders record using data below:
      | rts | 1 |

  @DeleteOrArchiveRoute @happy-path
  Scenario: Operator RTS Multiple Orders on All Orders Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    When Operator go to menu Order -> All Orders
    When Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator RTS multiple orders on next day on All Orders Page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
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
      | id  | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | rts | 1                                  |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RTS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE ADDRESS |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE CONTACT INFORMATION |
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
      | id  | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | rts | 1                                  |

  Scenario: Operator Resume Selected Cancelled Order on All Orders Page - Single Order
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    When Operator go to menu Order -> All Orders
    When Operator resume this order "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}" on All Orders page
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESUME |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Cancelled\nNew Granular Status: Pending Pickup\n\nOld Order Status: Cancelled\nNew Order Status: Pending\n\nReason: RESUME_ORDER |

  @happy-path
  Scenario: Operator Resume Selected Cancelled Order on All Orders Page - Multiple Orders
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And API Core - cancel order "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    And Operator go to menu Order -> All Orders
    When Operator resume multiple orders on All Orders page below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
    And Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESUME |
    And Operator verify order events on Edit Order V2 page using data below:
      | tags          | name          | description                                                                                                                                           |
      | MANUAL ACTION | UPDATE STATUS | Old Granular Status: Cancelled\nNew Granular Status: Pending Pickup\n\nOld Order Status: Cancelled\nNew Order Status: Pending\n\nReason: RESUME_ORDER |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verifies order details on Edit Order V2 page:
      | status         | Pending        |
      | granularStatus | Pending Pickup |
    And Operator verify Pickup details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery details on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Pickup transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify Delivery transaction on Edit Order V2 page using data below:
      | status | PENDING |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | RESUME |

  Scenario: Operator RTS Multiple Orders with Invalid Granular Status
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                 |
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                                          |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                     |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{gradle-next-1-working-day-yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | granularStatus | Completed                                  |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
      | granularStatus | Cancelled                                  |
    And API Core - Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDERS[3].id} |
      | granularStatus | Returned To Sender                         |
    When Operator go to menu Order -> All Orders
    And Operator find orders by uploading CSV on All Orders page:
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
    And Operator select 'Set RTS to Selected' action for found orders on All Orders page
    Then Operator verify "Return to Sender" process in Selection Error dialog on All Orders page
    And Operator verify orders info in Selection Error dialog on All Orders page:
      | trackingId                                 | reason                   |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} | Invalid status to change |
      | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} | Invalid status to change |
    When Operator clicks Continue button in Selection Error dialog on All Orders page
    Then Operator verifies that error toast displayed:
      | top    | Unable to apply actions |
      | bottom | No valid selection      |
    Then API Core - Verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | granularStatus | COMPLETED                                  |
    Then API Core - Verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | granularStatus | CANCELLED                                  |
    Then API Core - Verifies order state:
      | trackingId     | {KEY_LIST_OF_CREATED_ORDERS[3].trackingId} |
      | granularStatus | RETURNED_TO_SENDER                         |
